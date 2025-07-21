using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class Faq
{
    public int FaqId { get; set; }

    public int TagId { get; set; }

    public string Author { get; set; } = null!;

    public DateTime PublishDate { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public byte Status { get; set; }

    public DateTime? DeletedTime { get; set; }

    public long? DeletedUserId { get; set; }

    public int SortOrder { get; set; }

    public virtual Account CreatedUser { get; set; } = null!;

    public virtual Account? DeletedUser { get; set; }

    public virtual ICollection<FaqContent> FaqContents { get; set; } = new List<FaqContent>();

    public virtual FaqTag Tag { get; set; } = null!;

    public virtual Account? UpdatedUser { get; set; }
}
