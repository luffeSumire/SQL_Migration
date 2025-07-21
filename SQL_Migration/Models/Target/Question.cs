using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class Question
{
    public int QuestionId { get; set; }

    public string Title { get; set; } = null!;

    public int? ParentQuestionId { get; set; }

    public int? StepNumber { get; set; }

    public bool IsRenewed { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    public byte Status { get; set; }

    public DateTime? DeletedTime { get; set; }

    public long? DeletedUserId { get; set; }

    public int SortOrder { get; set; }

    /// <summary>
    /// 題型版型代號(對應頁面結構代號)
    /// </summary>
    public int? QuestionTemplate { get; set; }

    public virtual ICollection<CertificationAnswer> CertificationAnswers { get; set; } = new List<CertificationAnswer>();

    public virtual Account CreatedUser { get; set; } = null!;

    public virtual Account? DeletedUser { get; set; }

    public virtual ICollection<Question> InverseParentQuestion { get; set; } = new List<Question>();

    public virtual Question? ParentQuestion { get; set; }

    public virtual Account? UpdatedUser { get; set; }
}
