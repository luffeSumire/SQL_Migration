using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 給簡易CRUD用的，記錄dto的變數和各個欄位相對應data source (因為大部分dto都是直接對應資料表欄位，所以也可以看成是對應db table columms)
/// </summary>
public partial class SimpleDtoSetting
{
    public int? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public int? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    public int? Sequence { get; set; }

    public string? Lan { get; set; }

    /// <summary>
    /// 對應simple_model_setting的sid
    /// </summary>
    public long? ModelSid { get; set; }

    /// <summary>
    /// 此變數從哪一張表來
    /// </summary>
    public string? VarFromAs { get; set; }

    /// <summary>
    /// dto的變數名稱 (html 的 name 會參考此而產生)
    /// </summary>
    public string? VarName { get; set; }

    /// <summary>
    /// 描述此變數的作用
    /// </summary>
    public string? VarDescription { get; set; }

    /// <summary>
    /// 此變數的中文名稱
    /// </summary>
    public string? VarCname { get; set; }

    /// <summary>
    /// 變數預設值
    /// </summary>
    public string? VarDefaultValue { get; set; }

    /// <summary>
    /// 此變數應該會存什麼，字串 text，大量字串 textarea，數字 number，檔案上傳 (存檔案名稱) file，圖片上傳 (存檔案名稱) file_image，從別的資料來源存入 input_source，日期 date，時間日期 datetime
    /// </summary>
    public string? VarType { get; set; }

    /// <summary>
    /// 圖片上傳時裁切設定的寬 (若無則使用者自訂)
    /// </summary>
    public int? FileImageWidth { get; set; }

    /// <summary>
    /// 圖片上傳時裁切設定的高 (若無則使用者自訂)
    /// </summary>
    public int? FileImageHeight { get; set; }

    /// <summary>
    /// 如果var_type是input_source，程式會抓對應simple_input_source這張表的tag
    /// </summary>
    public string? InputSourceTag { get; set; }

    /// <summary>
    /// 檔案上傳限定的副檔名
    /// </summary>
    public string? FileUploadType { get; set; }

    /// <summary>
    /// 是否在列表顯示
    /// </summary>
    public byte? ShowOnList { get; set; }

    /// <summary>
    /// 0 = 可讀寫(預設)，1 = 唯讀(依然會送post出去)，2 = 禁止寫入(不會送post出去)
    /// </summary>
    public byte? ReadOnly { get; set; }

    /// <summary>
    /// 使用grid system，自定義class樣式
    /// </summary>
    public string? GridColCss { get; set; }

    /// <summary>
    /// 在列表內可以設定個別的style
    /// </summary>
    public string? TdStyle { get; set; }

    /// <summary>
    /// 要join的table as 名稱
    /// </summary>
    public string? JoinWithAs { get; set; }

    /// <summary>
    /// join後主要對應的欄位
    /// </summary>
    public string? JoinWithVarName { get; set; }

    /// <summary>
    /// 圖片上傳時的限制數量
    /// </summary>
    public int? FileImageQuality { get; set; }
}
