using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class MenuItem
{
    public string Id { get; set; } = null!;

    public string Title { get; set; } = null!;

    public string Link { get; set; } = null!;

    public string? Icon { get; set; }

    public string? ParentId { get; set; }

    public int SortOrder { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime UpdatedAt { get; set; }

    public bool? Status { get; set; }

    public virtual ICollection<MenuItem> InverseParent { get; set; } = new List<MenuItem>();

    public virtual MenuItem? Parent { get; set; }
}
