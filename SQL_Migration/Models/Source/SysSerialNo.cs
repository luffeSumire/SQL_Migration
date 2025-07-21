using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

public partial class SysSerialNo
{
    public long Sid { get; set; }

    public string? NoType { get; set; }

    public string? YearMonthDate { get; set; }

    public long? SeqNo { get; set; }
}
