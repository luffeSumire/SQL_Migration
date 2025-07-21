using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

public partial class CustomSocialAgencyToTag
{
    public int SocialAgencySid { get; set; }

    public int TagSid { get; set; }
}
