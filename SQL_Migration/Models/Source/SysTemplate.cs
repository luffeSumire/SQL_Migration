using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 前台模板
/// </summary>
public partial class SysTemplate
{
    public int? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public int? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    /// <summary>
    /// show template 的順序
    /// </summary>
    public int? Sequence { get; set; }

    public string? Lan { get; set; }

    /// <summary>
    /// 前端設計師設計好的模板名稱
    /// </summary>
    public string? TemplateName { get; set; }

    /// <summary>
    /// 模板顯示時若針對某個頁面要調整css時，css內容可以放在這
    /// </summary>
    public string? TemplateCss { get; set; }

    /// <summary>
    /// 模板顯示時若針對某個頁面要調整js時，js內容可以放在這
    /// </summary>
    public string? TemplateJs { get; set; }

    /// <summary>
    /// 如果MVC的Router找不到對應的controller，就會導向到front controller，讓controller參考此欄位show出對應的template
    /// </summary>
    public string? RouterUrl { get; set; }

    /// <summary>
    /// 此模板底下可以放置其它模板，以逗號分隔sid，呼叫模板的順序由左到右
    /// </summary>
    public string? ChildTemplateSid { get; set; }

    /// <summary>
    /// 此模板為header footer content哪一種類型
    /// </summary>
    public string? TemplateType { get; set; }

    /// <summary>
    /// 此模板的header
    /// </summary>
    public long? TemplateHeaderSid { get; set; }

    /// <summary>
    /// 此模板的footer
    /// </summary>
    public long? TemplateFooterSid { get; set; }

    /// <summary>
    /// 此頁是否需要驗證碼
    /// </summary>
    public byte? NeedCaptcha { get; set; }
}
