# 權限系統資料庫遷移分析

## 資料庫結構對比

### 舊系統 (EcoCampus_Maria3)
- **sys_groups** (7筆) - 權限群組
- **sys_account_groups** (16筆) - 帳號群組關聯
- **sys_rule** (62筆) - 權限規則 
- **sys_groups_rule** (400筆) - 群組權限關聯 (包含CRUD權限)

### 新系統 (Ecocampus_PreProduction)
- **permission_group** (1筆) - 權限群組
- **account_permission_group** (1筆) - 帳號群組關聯
- **permission** (172筆) - 權限清單 (每個功能的CRUD分開存)
- **permission_group_map** (172筆) - 群組權限對應

## 核心差異分析

### 1. 權限顆粒度變化
- **舊系統**: 一筆 sys_groups_rule 記錄包含 CRUD (c, r, u, d 欄位)
- **新系統**: 每個動作 (C/R/U/D) 都是獨立的 permission 記錄

### 2. 資料結構轉換

#### 群組對應
```
舊: sys_groups (sid, cname, remark, sequence)
新: permission_group (sid, groupCode, name, remark, sequence)
```

#### 帳號群組關聯
```
舊: sys_account_groups (target_sid, group_sid, type)
新: account_permission_group (accountSid, groupSid)  
```

#### 權限對應 (最複雜的轉換)
```
舊: sys_rule (sid, rule_name, url) + sys_groups_rule (c, r, u, d)
新: permission (sid, route, action) + permission_group_map (allow)
```

## 映射規則

### 從 permission_map.md 的對應關係
舊系統的 URL 需要根據 permission_map.md 對應到新系統的 route

例如:
- 舊: `sys/seo_manage` → 新: `/system/seo`
- 舊: `sys/groups_manage` → 新: `/permissions/groups`

### CRUD 權限展開
舊系統一筆 sys_groups_rule 記錄:
```sql
groups_sid=1, rule_sid=2, c=1, r=1, u=1, d=0
```

需要轉換為新系統 4筆 permission 記錄:
```sql
route='/system/seo', action='C' → allow=1
route='/system/seo', action='R' → allow=1  
route='/system/seo', action='U' → allow=1
route='/system/seo', action='D' → allow=0
```

## 遷移策略

### Phase 1: 權限群組遷移
1. 從 `sys_groups` 遷移到 `permission_group`
2. 保留原始的 sid 作為識別

### Phase 2: 帳號群組關聯遷移  
1. 從 `sys_account_groups` 遷移到 `account_permission_group`
2. 對應 target_sid → accountSid, group_sid → groupSid

### Phase 3: 權限明細遷移
1. 結合 `sys_rule` 和 `sys_groups_rule` 的資料
2. 根據 permission_map.md 將舊 URL 對應到新 route
3. 將 CRUD 權限拆解為獨立的 permission 記錄
4. 建立 permission_group_map 對應關係

## 注意事項

1. **URL對應**: 必須嚴格按照 permission_map.md 進行對應
2. **權限顆粒度**: 新系統每個動作都是獨立記錄，需要正確展開
3. **資料清理**: 在遷移前需要清空目標表的現有資料
4. **序列維護**: 保持原有的 sequence 順序
5. **時間戳記**: 新系統需要設定適當的 createTime/updateTime