using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 給簡易CRUD用的，記錄Model和針對這個Model的相關設定 (因為大部分Model都是直接對應資料表，所以也可以看成是對應db table)
/// </summary>
public partial class SimpleModelSetting
{
    public int? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public int? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public int? Sequence { get; set; }

    public string? Lan { get; set; }

    public long Sid { get; set; }

    /// <summary>
    /// 此頁面的名稱 (麵包屑的名稱)
    /// </summary>
    public string? ShowName { get; set; }

    /// <summary>
    /// 此Model的路徑
    /// </summary>
    public string? ModelPath { get; set; }

    /// <summary>
    /// 對應Model名稱
    /// </summary>
    public string? ModelName { get; set; }

    /// <summary>
    /// 使用delete或者update的時候，所使用的where value (大部分都用sid即可)
    /// </summary>
    public string? ModelPk { get; set; }

    /// <summary>
    /// 是否使用文字編輯器 &apos;single&apos;使用單頁籤，&apos;mulit&apos;使用多頁籤，&apos;no&apos;不使用
    /// </summary>
    public string? AddBookmark { get; set; }

    /// <summary>
    /// 呼叫ac_model-&gt;all以前，先呼叫where，where的內容放這
    /// </summary>
    public string? WhereFirst { get; set; }

    /// <summary>
    /// 其他post按鈕
    /// </summary>
    public string? OtherPost { get; set; }
}
