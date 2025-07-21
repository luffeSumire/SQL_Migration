using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 前台模板
/// </summary>
public partial class SysTemplateParam
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
    /// 對應template的sid
    /// </summary>
    public long? TemplateSid { get; set; }

    /// <summary>
    /// 對應模板內的變數名稱
    /// </summary>
    public string? VarName { get; set; }

    /// <summary>
    /// 此變數的中文名稱
    /// </summary>
    public string? VarCname { get; set; }

    /// <summary>
    /// 描述此變數的作用 (會吐什麼資料or資料格式...etc)
    /// </summary>
    public string? VarDescription { get; set; }

    /// <summary>
    /// 此變數的資料路徑 (model路徑)
    /// </summary>
    public string? ModelPath { get; set; }

    /// <summary>
    /// 此變數的資料來源 (model 名稱)
    /// </summary>
    public string? ModelName { get; set; }

    /// <summary>
    /// 此變數的資料來源使用的method名稱
    /// </summary>
    public string? ModelMethod { get; set; }

    /// <summary>
    /// parameter 內容 (以逗號分隔，並對應$router的路徑，未對應到的傳入null，未有$開頭的傳入固定值)
    /// </summary>
    public string? ModelMethodParameter { get; set; }

    /// <summary>
    /// post 內容 (以逗號分隔)
    /// </summary>
    public string? ModelMethodPost { get; set; }

    /// <summary>
    /// get 內容 (以逗號分隔)
    /// </summary>
    public string? ModelMethodGet { get; set; }

    /// <summary>
    /// 是否把整個$this-&gt;input都送進去 (可以給param_to_dto用)
    /// </summary>
    public byte? ModelSendThisInput { get; set; }

    /// <summary>
    /// 取得這個var以前，先抓取post過來的userCaptcha
    /// </summary>
    public string? UserCaptcha { get; set; }
}
