using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

public partial class CustomBookmarkType
{
    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public int Sid { get; set; }

    public int BookmarkSid { get; set; }

    public int Type { get; set; }

    public string? Content { get; set; }

    public string? Picinfo { get; set; }

    public int? PicinfoWidth { get; set; }

    public string? PicinfoDescription { get; set; }

    public string? PicinfoTitle { get; set; }

    public string? Iframe { get; set; }

    public int? IsBlank { get; set; }

    public string? LinkUrl { get; set; }

    public string? FileName { get; set; }

    public string? FileInfo { get; set; }

    public int? ChildType { get; set; }

    public long? ParentSid { get; set; }

    public int? Sequence { get; set; }

    public string? Lan { get; set; }
}
