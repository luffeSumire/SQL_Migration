using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

public partial class SysSysinfo
{
    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    public string? Sitename { get; set; }

    public string? Sitecompany { get; set; }

    public string? Subsitename { get; set; }

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

    public string? Metapragma { get; set; }

    public string? MetacacheControl { get; set; }

    public string? Metaexpires { get; set; }

    public string? Sysico { get; set; }

    public int? Useverify { get; set; }

    public string? Ipsource { get; set; }

    public int? Httpson { get; set; }

    public string? Bgpic { get; set; }

    public int? HttpsonFront { get; set; }

    public int? HttpsonEnd { get; set; }

    public int? IsTag { get; set; }

    public string? VerificationType { get; set; }

    public int? SmsApi { get; set; }

    public int? InvoiceApi { get; set; }

    public int? LineApi { get; set; }

    public string? ServiceToken { get; set; }

    public int? Sequence { get; set; }

    public string? Lan { get; set; }
}
