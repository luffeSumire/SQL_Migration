using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class UserToken
{
    public long Id { get; set; }

    public long AccountSid { get; set; }

    public Guid Token { get; set; }

    public DateTime ExpireDate { get; set; }

    public byte Status { get; set; }

    public string TokenType { get; set; } = null!;

    public DateTime CreateDate { get; set; }

    public DateTime? LastAccessDate { get; set; }

    public string? ClientInfo { get; set; }

    public virtual Account AccountS { get; set; } = null!;
}
