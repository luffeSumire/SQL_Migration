using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

public partial class SysMetadatum
{
    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public string? Startdate { get; set; }

    public string? Enddate { get; set; }

    public long Sid { get; set; }

    public string? Siteurl { get; set; }

    public string? Sitetitle { get; set; }

    public string? Metakeywords { get; set; }

    public string? Metadescription { get; set; }

    public string? Metacompany { get; set; }

    public string? Metacopyright { get; set; }

    public string? Metaauthor { get; set; }

    public string? Metaauthoremail { get; set; }

    public string? Metaauthorurl { get; set; }

    public string? Metacreationdate { get; set; }

    public string? Metarating { get; set; }

    public string? Metarobots { get; set; }

    public string? Metarevisitafter { get; set; }

    public string? Metapragma { get; set; }

    public string? MetacacheControl { get; set; }

    public string? Metaexpires { get; set; }

    public string? Sysico { get; set; }

    /// <summary>
    /// 搜尋提示
    /// </summary>
    public string? SearchKeyword { get; set; }

    /// <summary>
    /// 自填入瀏覽人數
    /// </summary>
    public int? ManualViewCount { get; set; }

    /// <summary>
    /// fb連結
    /// </summary>
    public string? FbLink { get; set; }

    /// <summary>
    /// line連結
    /// </summary>
    public string? LineLink { get; set; }

    public int? Sequence { get; set; }

    public string? Lan { get; set; }
}
