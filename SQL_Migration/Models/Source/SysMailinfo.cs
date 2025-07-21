using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

public partial class SysMailinfo
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

    public long? ClassificationSid { get; set; }

    public string? Cname { get; set; }

    public string? StoreName { get; set; }

    public string? Siteurl { get; set; }

    public int? Isbcc { get; set; }

    public int? Isrepeat { get; set; }

    public string? Subject { get; set; }

    public string? Fromname { get; set; }

    public string? Frommail { get; set; }

    public string? Addname { get; set; }

    public string? Addmail { get; set; }

    public int? Sequence { get; set; }

    public string? Lan { get; set; }

    /// <summary>
    /// email內文 (實際內文的變數用兩個大括號 ex: {{title}} ，讓工程師自己去取代)
    /// </summary>
    public string? Content { get; set; }
}
