using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using SQL_Migration.Models.Source;

namespace SQL_Migration.Data;

public partial class SourceDbContext : DbContext
{
    public SourceDbContext()
    {
    }

    public SourceDbContext(DbContextOptions<SourceDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Cm> Cms { get; set; }

    public virtual DbSet<CustomAnswerOption> CustomAnswerOptions { get; set; }

    public virtual DbSet<CustomAnswerType> CustomAnswerTypes { get; set; }

    public virtual DbSet<CustomArticle> CustomArticles { get; set; }

    public virtual DbSet<CustomArticleFileLink> CustomArticleFileLinks { get; set; }

    public virtual DbSet<CustomBookmark> CustomBookmarks { get; set; }

    public virtual DbSet<CustomBookmarkType> CustomBookmarkTypes { get; set; }

    public virtual DbSet<CustomCertificate> CustomCertificates { get; set; }

    public virtual DbSet<CustomCertification> CustomCertifications { get; set; }

    public virtual DbSet<CustomCertificationAnswer> CustomCertificationAnswers { get; set; }

    public virtual DbSet<CustomCertificationAnswerActionRecord> CustomCertificationAnswerActionRecords { get; set; }

    public virtual DbSet<CustomCertificationAnswerRecord> CustomCertificationAnswerRecords { get; set; }

    public virtual DbSet<CustomCertificationStepRecord> CustomCertificationStepRecords { get; set; }

    public virtual DbSet<CustomContact> CustomContacts { get; set; }

    public virtual DbSet<CustomEditer> CustomEditers { get; set; }

    public virtual DbSet<CustomEditerClassification> CustomEditerClassifications { get; set; }

    public virtual DbSet<CustomEmailSendRecord> CustomEmailSendRecords { get; set; }

    public virtual DbSet<CustomFlagarea> CustomFlagareas { get; set; }

    public virtual DbSet<CustomFlagareaDatum> CustomFlagareaData { get; set; }

    public virtual DbSet<CustomHomeSet> CustomHomeSets { get; set; }

    public virtual DbSet<CustomJob> CustomJobs { get; set; }

    public virtual DbSet<CustomMember> CustomMembers { get; set; }

    public virtual DbSet<CustomMemberJobPlace> CustomMemberJobPlaces { get; set; }

    public virtual DbSet<CustomMemberLevel> CustomMemberLevels { get; set; }

    public virtual DbSet<CustomMemberPath> CustomMemberPaths { get; set; }

    public virtual DbSet<CustomMessage> CustomMessages { get; set; }

    public virtual DbSet<CustomMessageLog> CustomMessageLogs { get; set; }

    public virtual DbSet<CustomNews> CustomNews { get; set; }

    public virtual DbSet<CustomPlace> CustomPlaces { get; set; }

    public virtual DbSet<CustomQuestion> CustomQuestions { get; set; }

    public virtual DbSet<CustomReleaseEnTw> CustomReleaseEnTws { get; set; }

    public virtual DbSet<CustomReleasePhoto> CustomReleasePhotos { get; set; }

    public virtual DbSet<CustomSchoolImport> CustomSchoolImports { get; set; }

    public virtual DbSet<CustomSchoolPrincipal> CustomSchoolPrincipals { get; set; }

    public virtual DbSet<CustomSchoolStatistic> CustomSchoolStatistics { get; set; }

    public virtual DbSet<CustomSocialAgency> CustomSocialAgencies { get; set; }

    public virtual DbSet<CustomSocialAgencyToTag> CustomSocialAgencyToTags { get; set; }

    public virtual DbSet<CustomTag> CustomTags { get; set; }

    public virtual DbSet<LineAction> LineActions { get; set; }

    public virtual DbSet<LineActionReg> LineActionRegs { get; set; }

    public virtual DbSet<LineLog> LineLogs { get; set; }

    public virtual DbSet<SimpleDtoSetting> SimpleDtoSettings { get; set; }

    public virtual DbSet<SimpleInputSource> SimpleInputSources { get; set; }

    public virtual DbSet<SimpleModelJoinSetting> SimpleModelJoinSettings { get; set; }

    public virtual DbSet<SimpleModelSetting> SimpleModelSettings { get; set; }

    public virtual DbSet<SysAccount> SysAccounts { get; set; }

    public virtual DbSet<SysAccountGroup> SysAccountGroups { get; set; }

    public virtual DbSet<SysBannerpic> SysBannerpics { get; set; }

    public virtual DbSet<SysCityarea> SysCityareas { get; set; }

    public virtual DbSet<SysCompany> SysCompanies { get; set; }

    public virtual DbSet<SysCompanyJobTitle> SysCompanyJobTitles { get; set; }

    public virtual DbSet<SysFilesStore> SysFilesStores { get; set; }

    public virtual DbSet<SysGroup> SysGroups { get; set; }

    public virtual DbSet<SysGroupsRule> SysGroupsRules { get; set; }

    public virtual DbSet<SysLanguageDatum> SysLanguageData { get; set; }

    public virtual DbSet<SysLoginProcess> SysLoginProcesses { get; set; }

    public virtual DbSet<SysMailLog> SysMailLogs { get; set; }

    public virtual DbSet<SysMailSmtp> SysMailSmtps { get; set; }

    public virtual DbSet<SysMailinfo> SysMailinfos { get; set; }

    public virtual DbSet<SysMetadatum> SysMetadata { get; set; }

    public virtual DbSet<SysModule> SysModules { get; set; }

    public virtual DbSet<SysRule> SysRules { get; set; }

    public virtual DbSet<SysSerialNo> SysSerialNos { get; set; }

    public virtual DbSet<SysSysinfo> SysSysinfos { get; set; }

    public virtual DbSet<SysTemplate> SysTemplates { get; set; }

    public virtual DbSet<SysTemplateParam> SysTemplateParams { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=VM-MSSQL-2022;Database=EcoCampus_Maria3;User ID=ecocampus;Password=42949337;TrustServerCertificate=True;");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Cm>(entity =>
        {
            entity.HasKey(e => e.Dsn).HasName("PK__cms__D876E1F951843735");

            entity.ToTable("cms");

            entity.Property(e => e.Dsn)
                .ValueGeneratedNever()
                .HasComment("流水號")
                .HasColumnName("dsn");
            entity.Property(e => e.Body)
                .HasComment("內容")
                .HasColumnName("body");
            entity.Property(e => e.COrder)
                .HasComment("排序")
                .HasColumnName("cOrder");
            entity.Property(e => e.DocId)
                .HasComment("文章群組號")
                .HasColumnName("docId");
            entity.Property(e => e.ETime)
                .HasComment("下架日期")
                .HasColumnName("eTime");
            entity.Property(e => e.EsTime)
                .HasComment("建立時間")
                .HasColumnName("esTime");
            entity.Property(e => e.EsUsrId)
                .HasMaxLength(25)
                .HasComment("建立者")
                .HasColumnName("esUsrId");
            entity.Property(e => e.FlagDisable)
                .HasComment("是否停用")
                .HasColumnName("flagDisable");
            entity.Property(e => e.FlagIndex).HasColumnName("flagIndex");
            entity.Property(e => e.LangId)
                .HasComment("語系")
                .HasColumnName("langId");
            entity.Property(e => e.ProgId)
                .HasMaxLength(50)
                .HasComment("程式編號")
                .HasColumnName("progId");
            entity.Property(e => e.Remarks)
                .HasMaxLength(200)
                .HasColumnName("remarks");
            entity.Property(e => e.STime)
                .HasComment("上架日期")
                .HasColumnName("sTime");
            entity.Property(e => e.Title)
                .HasComment("標題")
                .HasColumnName("title");
            entity.Property(e => e.UpTime)
                .HasComment("更新時間")
                .HasColumnName("upTime");
            entity.Property(e => e.UpUsrId)
                .HasMaxLength(25)
                .HasComment("修改者")
                .HasColumnName("upUsrId");
            entity.Property(e => e.UsrId)
                .HasMaxLength(25)
                .HasColumnName("usrId");
            entity.Property(e => e.Ver)
                .HasComment("版本")
                .HasColumnName("ver");
        });

        modelBuilder.Entity<CustomAnswerOption>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_a__DDDFDD361308B663");

            entity.ToTable("custom_answer_option", tb => tb.HasComment("回答選項；如果選擇回答方式為選項(如select)類型，用於建立選項(如option)"));

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.AnswerTypeSid)
                .HasComment("多選或單選所對應的回答方式sid")
                .HasColumnName("answer_type_sid");
            entity.Property(e => e.Cname)
                .HasMaxLength(40)
                .HasComment("選項名稱，如：學生、老師、其他")
                .HasColumnName("cname");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.InputUse)
                .HasComment("若選項後面是可以提供文字輸入的時候，需要開啟；1:使用、0:不使用")
                .HasColumnName("input_use");
            entity.Property(e => e.IsUse)
                .HasComment("是否啟用；1:使用、0:不使用")
                .HasColumnName("is_use");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<CustomAnswerType>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_a__DDDFDD3678234BDD");

            entity.ToTable("custom_answer_type", tb => tb.HasComment("回答方式；題目的回答方式建立"));

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.AnswerType)
                .HasMaxLength(255)
                .HasComment("填充:'input', 是非:'yes_no',上傳:'file',文字區塊:'textarea',多選勾選:'checkbox',單選下拉:'select',單選點擊:'radio',日期:'date',日期區間:'date_range'")
                .HasColumnName("answer_type");
            entity.Property(e => e.Cname)
                .HasMaxLength(70)
                .HasComment("回答方式名稱；如：學生姓名、學生年級、分工任務")
                .HasColumnName("cname");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.IsUse)
                .HasComment("是否啟用；1:使用、0:不使用")
                .HasColumnName("is_use");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.QuestionSid)
                .HasComment("回答方式所對應的題目sid")
                .HasColumnName("question_sid");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<CustomArticle>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_a__DDDFDD368E90C1D9");

            entity.ToTable("custom_article", tb => tb.HasComment("文字編輯器內容"));

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Enddate)
                .HasMaxLength(20)
                .HasComment("結束日期(yyyy-mm-dd)")
                .HasColumnName("enddate");
            entity.Property(e => e.Explanation)
                .HasComment("簡述說明")
                .HasColumnName("explanation");
            entity.Property(e => e.Fileinfo)
                .HasComment("檔案")
                .HasColumnName("fileinfo");
            entity.Property(e => e.Hits).HasColumnName("hits");
            entity.Property(e => e.IsBlank)
                .HasComment("是否另開(配合連結使用)")
                .HasColumnName("is_blank");
            entity.Property(e => e.IsHome)
                .HasComment("是否顯示於首頁")
                .HasColumnName("is_home");
            entity.Property(e => e.IsShow)
                .HasComment("是否顯示")
                .HasColumnName("is_show");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.Link)
                .HasComment("連結")
                .HasColumnName("link");
            entity.Property(e => e.Other)
                .HasComment("特殊欄位")
                .HasColumnName("other");
            entity.Property(e => e.Photo)
                .HasComment("圖片")
                .HasColumnName("photo");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Startdate)
                .HasMaxLength(20)
                .HasComment("開始日期(yyyy-mm-dd)")
                .HasColumnName("startdate");
            entity.Property(e => e.TagAry)
                .HasComment("多組標籤使用")
                .HasColumnName("tag_ary");
            entity.Property(e => e.TagSid)
                .HasComment("標籤sid 做分類使用")
                .HasColumnName("tag_sid");
            entity.Property(e => e.Title)
                .HasMaxLength(200)
                .HasComment("標題")
                .HasColumnName("title");
            entity.Property(e => e.Type)
                .HasMaxLength(255)
                .HasComment("news:最新消息,video:精選影片,about:簡介,execute:執行方式,certification:認證介紹,fqa:常見問題,release:校園投稿說明,file_dl:檔案下載,related:友善連結")
                .HasColumnName("type");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<CustomArticleFileLink>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_a__DDDFDD3628560E5D");

            entity.ToTable("custom_article_file_link", tb => tb.HasComment("用於管理相關連結及檔案下載"));

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Fileinfo)
                .HasComment("上傳的檔案")
                .HasColumnName("fileinfo");
            entity.Property(e => e.FileinfoOdt)
                .HasComment("上傳的檔案(odt)")
                .HasColumnName("fileinfo_odt");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.LinkUrl)
                .HasComment("相關連結的url")
                .HasColumnName("link_url");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.TableName)
                .HasMaxLength(30)
                .HasComment("使用連結或檔案的名稱")
                .HasColumnName("table_name");
            entity.Property(e => e.TableSid)
                .HasComment("使用連結或檔案的表sid")
                .HasColumnName("table_sid");
            entity.Property(e => e.Title)
                .HasMaxLength(100)
                .HasComment("檔案下載標題或相關連結名稱")
                .HasColumnName("title");
            entity.Property(e => e.Type)
                .HasMaxLength(255)
                .HasComment("file:檔案,link:連結")
                .HasColumnName("type");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<CustomBookmark>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_b__DDDFDD36D2D3E40D");

            entity.ToTable("custom_bookmark");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Cname)
                .HasMaxLength(200)
                .HasColumnName("cname");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.TableCname)
                .HasMaxLength(255)
                .HasColumnName("table_cname");
            entity.Property(e => e.TableSid).HasColumnName("table_sid");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<CustomBookmarkType>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_b__DDDFDD36835BADE9");

            entity.ToTable("custom_bookmark_type");

            entity.HasIndex(e => e.BookmarkSid, "bookmark_sid");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.BookmarkSid).HasColumnName("bookmark_sid");
            entity.Property(e => e.ChildType).HasColumnName("child_type");
            entity.Property(e => e.Content).HasColumnName("content");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.FileInfo)
                .HasMaxLength(100)
                .HasColumnName("file_info");
            entity.Property(e => e.FileName)
                .HasMaxLength(200)
                .HasColumnName("file_name");
            entity.Property(e => e.Iframe).HasColumnName("iframe");
            entity.Property(e => e.IsBlank).HasColumnName("is_blank");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.LinkUrl)
                .HasMaxLength(255)
                .HasColumnName("link_url");
            entity.Property(e => e.ParentSid).HasColumnName("parent_sid");
            entity.Property(e => e.Picinfo).HasColumnName("picinfo");
            entity.Property(e => e.PicinfoDescription)
                .HasMaxLength(255)
                .HasColumnName("picinfo_description");
            entity.Property(e => e.PicinfoTitle)
                .HasMaxLength(255)
                .HasColumnName("picinfo_title");
            entity.Property(e => e.PicinfoWidth).HasColumnName("picinfo_width");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Type).HasColumnName("type");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<CustomCertificate>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_c__DDDFDD3603A46D4A");

            entity.ToTable("custom_certificate", tb => tb.HasComment("證書(很重要2、3、4 sid 不可以刪 對應 銅銀綠旗證書)"));

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Cname)
                .HasMaxLength(50)
                .HasComment("證書名稱")
                .HasColumnName("cname");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.IsUse)
                .HasComment("是否使用；1:使用、0:不使用")
                .HasColumnName("is_use");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
            entity.Property(e => e.Version)
                .HasMaxLength(30)
                .HasComment("版本號")
                .HasColumnName("version");
        });

        modelBuilder.Entity<CustomCertification>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_c__DDDFDD365967FABE");

            entity.ToTable("custom_certification", tb => tb.HasComment("使用者認證"));

            entity.HasIndex(e => e.MemberSid, "custom_certification_ibfk_1");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.AddType)
                .HasMaxLength(255)
                .HasComment("新增方式")
                .HasColumnName("add_type");
            entity.Property(e => e.Additionaldate)
                .HasMaxLength(20)
                .HasComment("補件時間")
                .HasColumnName("additionaldate");
            entity.Property(e => e.CertificateSid)
                .HasComment("證書編號")
                .HasColumnName("certificate_sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.IsDel)
                .HasComment("刪除")
                .HasColumnName("is_del");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.Level)
                .HasComment("等級")
                .HasColumnName("level");
            entity.Property(e => e.MemberSid)
                .HasComment("使用者編號")
                .HasColumnName("member_sid");
            entity.Property(e => e.Passdate)
                .HasMaxLength(20)
                .HasComment("通過時間")
                .HasColumnName("passdate");
            entity.Property(e => e.PdfFile)
                .HasComment("檔案")
                .HasColumnName("pdf_file");
            entity.Property(e => e.Returndate)
                .HasMaxLength(20)
                .HasComment("退件時間")
                .HasColumnName("returndate");
            entity.Property(e => e.Review)
                .HasMaxLength(255)
                .HasComment("審核")
                .HasColumnName("review");
            entity.Property(e => e.Reviewdate)
                .HasMaxLength(20)
                .HasComment("送審日期")
                .HasColumnName("reviewdate");
            entity.Property(e => e.Rewardhistory)
                .HasComment("獎牌歷史")
                .HasColumnName("rewardhistory");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");

            entity.HasOne(d => d.MemberS).WithMany(p => p.CustomCertifications)
                .HasForeignKey(d => d.MemberSid)
                .HasConstraintName("custom_certification_ibfk_1");
        });

        modelBuilder.Entity<CustomCertificationAnswer>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_c__DDDFDD363182599A");

            entity.ToTable("custom_certification_answer", tb => tb.HasComment("使用者認證回答"));

            entity.HasIndex(e => e.CertificationSid, "custom_certification_answer_ibfk_1");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.CertificationSid)
                .HasComment("認證編號")
                .HasColumnName("certification_sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.QuestionSid)
                .HasComment("題目編號")
                .HasColumnName("question_sid");
            entity.Property(e => e.ReviewCertificationAnswerRecordSid).HasColumnName("review_certification_answer_record_sid");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
            entity.Property(e => e.UseCertificationAnswerRecordSid).HasColumnName("use_certification_answer_record_sid");

            entity.HasOne(d => d.CertificationS).WithMany(p => p.CustomCertificationAnswers)
                .HasForeignKey(d => d.CertificationSid)
                .HasConstraintName("custom_certification_answer_ibfk_1");
        });

        modelBuilder.Entity<CustomCertificationAnswerActionRecord>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_c__DDDFDD36012335B2");

            entity.ToTable("custom_certification_answer_action_record", tb => tb.HasComment("使用者認證回答紀錄"));

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.CertificationAnswerRecordSid).HasColumnName("certification_answer_record_sid");
            entity.Property(e => e.CertificationAnswerSid)
                .HasComment("答案編號")
                .HasColumnName("certification_answer_sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.RecordContent)
                .HasMaxLength(200)
                .HasColumnName("record_content");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<CustomCertificationAnswerRecord>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_c__DDDFDD36D5FB4B45");

            entity.ToTable("custom_certification_answer_record", tb => tb.HasComment("使用者認證回答紀錄"));

            entity.HasIndex(e => e.CertificationAnswerSid, "custom_certification_answer_record_ibfk_1");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.AnswerJson)
                .HasComment("答案紀錄")
                .HasColumnName("answer_json");
            entity.Property(e => e.CertificationAnswerSid)
                .HasComment("答案編號")
                .HasColumnName("certification_answer_sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.Opinion)
                .HasComment("評審意見")
                .HasColumnName("opinion");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Status)
                .HasMaxLength(255)
                .HasColumnName("status");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");

            entity.HasOne(d => d.CertificationAnswerS).WithMany(p => p.CustomCertificationAnswerRecords)
                .HasForeignKey(d => d.CertificationAnswerSid)
                .HasConstraintName("custom_certification_answer_record_ibfk_1");
        });

        modelBuilder.Entity<CustomCertificationStepRecord>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_c__DDDFDD36AEE9048B");

            entity.ToTable("custom_certification_step_record", tb => tb.HasComment("使用者認證步驟紀錄"));

            entity.HasIndex(e => e.CertificationSid, "custom_certification_step_record_ibfk_1");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.CertificationSid)
                .HasComment("認證編號")
                .HasColumnName("certification_sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Step).HasColumnName("step");
            entity.Property(e => e.StepOpinion)
                .HasComment("步驟評審意見")
                .HasColumnName("step_opinion");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");

            entity.HasOne(d => d.CertificationS).WithMany(p => p.CustomCertificationStepRecords)
                .HasForeignKey(d => d.CertificationSid)
                .HasConstraintName("custom_certification_step_record_ibfk_1");
        });

        modelBuilder.Entity<CustomContact>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_c__DDDFDD36C2ED646E");

            entity.ToTable("custom_contact", tb => tb.HasComment("聯絡人基本資料"));

            entity.HasIndex(e => e.MemberSid, "custom_contact_ibfk_1");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.ContactCname)
                .HasMaxLength(20)
                .HasComment("聯絡人名稱(中文)")
                .HasColumnName("contact_cname");
            entity.Property(e => e.ContactCnameEn)
                .HasMaxLength(50)
                .HasComment("聯絡人名稱(英文)")
                .HasColumnName("contact_cname_en");
            entity.Property(e => e.ContactEmail)
                .HasMaxLength(50)
                .HasComment("信箱")
                .HasColumnName("contact_email");
            entity.Property(e => e.ContactFax)
                .HasMaxLength(20)
                .HasComment("傳真")
                .HasColumnName("contact_fax");
            entity.Property(e => e.ContactJobCname)
                .HasMaxLength(50)
                .HasComment("聯絡人職稱")
                .HasColumnName("contact_job_cname");
            entity.Property(e => e.ContactJobSid)
                .HasComment("職稱sid")
                .HasColumnName("contact_job_sid");
            entity.Property(e => e.ContactPhone)
                .HasMaxLength(20)
                .HasComment("手機")
                .HasColumnName("contact_phone");
            entity.Property(e => e.ContactTel)
                .HasMaxLength(20)
                .HasComment("電話")
                .HasColumnName("contact_tel");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.MemberSid)
                .HasComment("使用者編號")
                .HasColumnName("member_sid");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");

            entity.HasOne(d => d.MemberS).WithMany(p => p.CustomContacts)
                .HasForeignKey(d => d.MemberSid)
                .HasConstraintName("custom_contact_ibfk_1");
        });

        modelBuilder.Entity<CustomEditer>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_e__DDDFDD363475BBFA");

            entity.ToTable("custom_editer");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.ClassificationSid).HasColumnName("classification_sid");
            entity.Property(e => e.Cname)
                .HasMaxLength(30)
                .HasColumnName("cname");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.IsAdmin)
                .HasComment("是否為系統開發者帳號 0:否 1:是")
                .HasColumnName("is_admin");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<CustomEditerClassification>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_e__DDDFDD36E4E3EE07");

            entity.ToTable("custom_editer_classification");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Cname)
                .HasMaxLength(30)
                .HasColumnName("cname");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.IsButton).HasColumnName("is_button");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.NickName)
                .HasMaxLength(30)
                .HasColumnName("nick_name");
            entity.Property(e => e.Nlevel).HasColumnName("nlevel");
            entity.Property(e => e.ParentSid).HasColumnName("parent_sid");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<CustomEmailSendRecord>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_e__DDDFDD36BDE9B831");

            entity.ToTable("custom_email_send_record", tb => tb.HasComment("使用者認證步驟紀錄"));

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.MemberSid).HasColumnName("member_sid");
            entity.Property(e => e.SendDate)
                .HasMaxLength(20)
                .HasColumnName("send_date");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Type)
                .HasMaxLength(255)
                .HasColumnName("type");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<CustomFlagarea>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_f__DDDFDD36A4CDDB2D");

            entity.ToTable("custom_flagarea");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Course)
                .HasMaxLength(2048)
                .HasColumnName("course");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Declaration)
                .HasMaxLength(2048)
                .HasColumnName("declaration");
            entity.Property(e => e.DeclarationTitle)
                .HasMaxLength(50)
                .HasColumnName("declaration_title");
            entity.Property(e => e.Feature)
                .HasMaxLength(2048)
                .HasColumnName("feature");
            entity.Property(e => e.Image)
                .HasMaxLength(255)
                .HasColumnName("image");
            entity.Property(e => e.Intro)
                .HasMaxLength(2048)
                .HasColumnName("intro");
            entity.Property(e => e.School)
                .HasMaxLength(32)
                .HasColumnName("school");
            entity.Property(e => e.Status).HasColumnName("status");
            entity.Property(e => e.Title)
                .HasMaxLength(64)
                .HasColumnName("title");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<CustomFlagareaDatum>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_f__DDDFDD36CCF85DC7");

            entity.ToTable("custom_flagarea_data");

            entity.HasIndex(e => e.FlagSid, "flag_sid");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Content)
                .HasMaxLength(2048)
                .HasColumnName("content");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.FlagSid).HasColumnName("flag_sid");
            entity.Property(e => e.Link)
                .HasMaxLength(255)
                .HasColumnName("link");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Title)
                .HasMaxLength(64)
                .HasColumnName("title");
            entity.Property(e => e.Type)
                .HasMaxLength(255)
                .HasColumnName("type");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<CustomHomeSet>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_h__DDDFDD3678E90E8C");

            entity.ToTable("custom_home_set", tb => tb.HasComment("首頁設定(首頁要求高度客製化,因此基本上都是欄位對應文字編輯器)"));

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Cname)
                .HasMaxLength(200)
                .HasComment("區塊名稱(設定以及管理者看到)")
                .HasColumnName("cname");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.IsBlank)
                .HasComment("是否另開")
                .HasColumnName("is_blank");
            entity.Property(e => e.IsEdit)
                .HasComment("文字編輯器")
                .HasColumnName("is_edit");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.Msg)
                .HasComment("純文字內容")
                .HasColumnName("msg");
            entity.Property(e => e.Other)
                .HasComment("特殊欄位")
                .HasColumnName("other");
            entity.Property(e => e.PHeight)
                .HasComment("圖片高")
                .HasColumnName("p_height");
            entity.Property(e => e.PWidth)
                .HasComment("圖片寬")
                .HasColumnName("p_width");
            entity.Property(e => e.Photo)
                .HasComment("圖片")
                .HasColumnName("photo");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.ShowAry)
                .HasComment("顯示設定[白名單]")
                .HasColumnName("show_ary");
            entity.Property(e => e.Siteurl)
                .HasComment("連結")
                .HasColumnName("siteurl");
            entity.Property(e => e.Tag)
                .HasMaxLength(30)
                .HasComment("tag名稱(工程師辨識用,方便透過tag直接抓資料)")
                .HasColumnName("tag");
            entity.Property(e => e.Title)
                .HasComment("標題")
                .HasColumnName("title");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<CustomJob>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_j__DDDFDD36BFF30A5D");

            entity.ToTable("custom_job", tb => tb.HasComment("使用者的職稱"));

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Enddate)
                .HasMaxLength(20)
                .HasComment("下架時間")
                .HasColumnName("enddate");
            entity.Property(e => e.JobCname)
                .HasMaxLength(30)
                .HasComment("名稱")
                .HasColumnName("job_cname");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.PlaceSid)
                .HasComment("單位sid")
                .HasColumnName("place_sid");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Startdate)
                .HasMaxLength(20)
                .HasComment("上架時間")
                .HasColumnName("startdate");
            entity.Property(e => e.Type)
                .HasMaxLength(255)
                .HasComment("school:生態學校,epa:環保人員,tutor:輔導人員")
                .HasColumnName("type");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<CustomMember>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_m__DDDFDD3653BCFB38");

            entity.ToTable("custom_member", tb => tb.HasComment("紀錄各身份使用者資料"));

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Account)
                .HasMaxLength(50)
                .HasComment("帳號")
                .HasColumnName("account");
            entity.Property(e => e.AreaAttributes)
                .HasMaxLength(255)
                .HasComment("地區屬性 ('general'=>一般 ,'remote'=>偏遠 ,'particularly'=>特偏 ,'extremely_biased'=>極偏)")
                .HasColumnName("area_attributes");
            entity.Property(e => e.AreaSid)
                .HasComment("地區sid")
                .HasColumnName("area_sid");
            entity.Property(e => e.Captcha)
                .HasComment("驗證碼")
                .HasColumnName("captcha");
            entity.Property(e => e.CitizenDigitalNumber)
                .HasMaxLength(255)
                .HasComment("自然人憑證序號")
                .HasColumnName("citizen_digital_number");
            entity.Property(e => e.CitySid)
                .HasComment("縣市sid")
                .HasColumnName("city_sid");
            entity.Property(e => e.Code)
                .HasMaxLength(12)
                .HasComment("學校代碼")
                .HasColumnName("code");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.GroupsSid).HasColumnName("groups_sid");
            entity.Property(e => e.IsDel)
                .HasComment("假刪除；1:是、0:否")
                .HasColumnName("is_del");
            entity.Property(e => e.IsInternal)
                .HasComment("內部測試；1:是、0:否")
                .HasColumnName("is_internal");
            entity.Property(e => e.Isuse)
                .HasComment("是否啟用；1:是、0:否")
                .HasColumnName("isuse");
            entity.Property(e => e.JobCname)
                .HasMaxLength(60)
                .HasComment("職稱名稱")
                .HasColumnName("job_cname");
            entity.Property(e => e.JobSid).HasColumnName("job_sid");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.MemberAddress)
                .HasMaxLength(100)
                .HasComment("地址")
                .HasColumnName("member_address");
            entity.Property(e => e.MemberAddressEn)
                .HasMaxLength(200)
                .HasComment("地址(英文)")
                .HasColumnName("member_address_en");
            entity.Property(e => e.MemberCname)
                .HasMaxLength(100)
                .HasComment("使用者名稱")
                .HasColumnName("member_cname");
            entity.Property(e => e.MemberCnameEn)
                .HasMaxLength(200)
                .HasComment("使用者名稱(英文)")
                .HasColumnName("member_cname_en");
            entity.Property(e => e.MemberEmail)
                .HasMaxLength(100)
                .HasComment("使用者信箱")
                .HasColumnName("member_email");
            entity.Property(e => e.MemberExchange)
                .HasMaxLength(50)
                .HasComment("1:是、0:否")
                .HasColumnName("member_exchange");
            entity.Property(e => e.MemberIntroduction)
                .HasComment("使用者介紹")
                .HasColumnName("member_Introduction");
            entity.Property(e => e.MemberIntroductionEn)
                .HasComment("使用者介紹(英文)")
                .HasColumnName("member_Introduction_en");
            entity.Property(e => e.MemberPassdate)
                .HasMaxLength(20)
                .HasComment("通過時間")
                .HasColumnName("member_passdate");
            entity.Property(e => e.MemberPhone)
                .HasMaxLength(20)
                .HasComment("使用者手機")
                .HasColumnName("member_phone");
            entity.Property(e => e.MemberPhoto)
                .HasComment("使用者照片")
                .HasColumnName("member_photo");
            entity.Property(e => e.MemberRole)
                .HasMaxLength(255)
                .HasComment("使用者身份；生態學校:school, 環保局人員:epa , 輔導人員:tutor")
                .HasColumnName("member_role");
            entity.Property(e => e.MemberTel)
                .HasMaxLength(20)
                .HasComment("使用者電話")
                .HasColumnName("member_tel");
            entity.Property(e => e.MemberUrl).HasColumnName("member_url");
            entity.Property(e => e.Password)
                .HasComment("密碼")
                .HasColumnName("password");
            entity.Property(e => e.PasswordSalt)
                .HasMaxLength(50)
                .HasComment("密碼加密編碼")
                .HasColumnName("password_salt");
            entity.Property(e => e.PlaceCname)
                .HasMaxLength(60)
                .HasComment("單位名稱")
                .HasColumnName("place_cname");
            entity.Property(e => e.PlaceSid).HasColumnName("place_sid");
            entity.Property(e => e.RegisterReview)
                .HasMaxLength(255)
                .HasColumnName("register_review");
            entity.Property(e => e.ReviewMemberRecordSid).HasColumnName("review_member_record_sid");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.TagSid)
                .HasComment("使用者身份的分類sid")
                .HasColumnName("tag_sid");
            entity.Property(e => e.UpdatePasswordDateNew)
                .HasComment("轉換用的新密碼更新時間")
                .HasColumnName("update_password_date_new");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
            entity.Property(e => e.UseMemberRecordSid).HasColumnName("use_member_record_sid");
        });

        modelBuilder.Entity<CustomMemberJobPlace>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_m__DDDFDD3646882E1F");

            entity.ToTable("custom_member_job_place", tb => tb.HasComment("使用者的服務單位及職稱關聯"));

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Enddate)
                .HasMaxLength(20)
                .HasComment("下架時間")
                .HasColumnName("enddate");
            entity.Property(e => e.JobSid)
                .HasMaxLength(100)
                .HasComment("職稱sid")
                .HasColumnName("job_sid");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.MemberSid)
                .HasComment("使用者sid")
                .HasColumnName("member_sid");
            entity.Property(e => e.PlaceSid)
                .HasComment("單位sid")
                .HasColumnName("place_sid");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Startdate)
                .HasMaxLength(20)
                .HasComment("上架時間")
                .HasColumnName("startdate");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<CustomMemberLevel>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_m__DDDFDD36BDF3520F");

            entity.ToTable("custom_member_level", tb => tb.HasComment("使用者認證等級"));

            entity.HasIndex(e => e.MemberSid, "custom_member_level_ibfk_1");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.CertificationSid)
                .HasComment("認證編號")
                .HasColumnName("certification_sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Effectiveness)
                .HasComment("有效性")
                .HasColumnName("effectiveness");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.Level)
                .HasComment("等級")
                .HasColumnName("level");
            entity.Property(e => e.MemberSid)
                .HasComment("使用者編號")
                .HasColumnName("member_sid");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");

            entity.HasOne(d => d.MemberS).WithMany(p => p.CustomMemberLevels)
                .HasForeignKey(d => d.MemberSid)
                .HasConstraintName("custom_member_level_ibfk_1");
        });

        modelBuilder.Entity<CustomMemberPath>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_m__DDDFDD3698EAB859");

            entity.ToTable("custom_member_path", tb => tb.HasComment("使用者環境路徑"));

            entity.HasIndex(e => e.MemberSid, "custom_member_path_ibfk_1");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Biological)
                .HasComment("生物多樣性")
                .HasColumnName("biological");
            entity.Property(e => e.Consume)
                .HasComment("消耗與廢棄物")
                .HasColumnName("consume");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Energy)
                .HasComment("能源")
                .HasColumnName("energy");
            entity.Property(e => e.Food)
                .HasComment("永續食物")
                .HasColumnName("food");
            entity.Property(e => e.Forest)
                .HasComment("森林")
                .HasColumnName("forest");
            entity.Property(e => e.Habitat)
                .HasComment("學校棲地")
                .HasColumnName("habitat");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.LevelSid)
                .HasComment("使用者編號")
                .HasColumnName("level_sid");
            entity.Property(e => e.Life)
                .HasComment("健康生活")
                .HasColumnName("life");
            entity.Property(e => e.MemberSid)
                .HasComment("使用者編號")
                .HasColumnName("member_sid");
            entity.Property(e => e.Protection)
                .HasComment("水體保護")
                .HasColumnName("protection");
            entity.Property(e => e.School)
                .HasComment("健康校園")
                .HasColumnName("school");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Traffic)
                .HasComment("交通")
                .HasColumnName("traffic");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
            entity.Property(e => e.Water)
                .HasComment("水")
                .HasColumnName("water");
            entity.Property(e => e.Weather)
                .HasComment("氣候")
                .HasColumnName("weather");

            entity.HasOne(d => d.MemberS).WithMany(p => p.CustomMemberPaths)
                .HasForeignKey(d => d.MemberSid)
                .HasConstraintName("custom_member_path_ibfk_1");
        });

        modelBuilder.Entity<CustomMessage>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("custom_message");

            entity.Property(e => e.Content).HasColumnName("content");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.ScheduleDate).HasColumnName("schedule_date");
            entity.Property(e => e.ScheduleTime).HasColumnName("schedule_time");
            entity.Property(e => e.Sender)
                .HasMaxLength(32)
                .HasColumnName("sender");
            entity.Property(e => e.Sid).HasColumnName("sid");
            entity.Property(e => e.Status).HasColumnName("status");
            entity.Property(e => e.Subject)
                .HasMaxLength(64)
                .HasColumnName("subject");
            entity.Property(e => e.Target).HasColumnName("target");
            entity.Property(e => e.TargetCustom).HasColumnName("target_custom");
            entity.Property(e => e.TargetUser).HasColumnName("target_user");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<CustomMessageLog>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("custom_message_log");

            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Email)
                .HasMaxLength(255)
                .HasColumnName("email");
            entity.Property(e => e.Level).HasColumnName("level");
            entity.Property(e => e.MessageSid).HasColumnName("message_sid");
            entity.Property(e => e.Role)
                .HasMaxLength(32)
                .HasColumnName("role");
            entity.Property(e => e.School)
                .HasMaxLength(32)
                .HasColumnName("school");
            entity.Property(e => e.Sid).HasColumnName("sid");
            entity.Property(e => e.Status).HasColumnName("status");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
        });

        modelBuilder.Entity<CustomNews>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_n__DDDFDD3628D01AA5");

            entity.ToTable("custom_news", tb => tb.HasComment("文字編輯器內容"));

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Enddate)
                .HasMaxLength(20)
                .HasComment("結束日期(yyyy-mm-dd)")
                .HasColumnName("enddate");
            entity.Property(e => e.Explanation)
                .HasComment("簡述說明")
                .HasColumnName("explanation");
            entity.Property(e => e.Fileinfo)
                .HasComment("檔案")
                .HasColumnName("fileinfo");
            entity.Property(e => e.IsBlank)
                .HasComment("是否另開(配合連結使用)")
                .HasColumnName("is_blank");
            entity.Property(e => e.IsHome)
                .HasComment("是否顯示於首頁")
                .HasColumnName("is_home");
            entity.Property(e => e.IsShow)
                .HasComment("是否顯示")
                .HasColumnName("is_show");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.Link)
                .HasComment("連結")
                .HasColumnName("link");
            entity.Property(e => e.MemberSid)
                .HasComment("使用者sid")
                .HasColumnName("member_sid");
            entity.Property(e => e.Other)
                .HasComment("特殊欄位")
                .HasColumnName("other");
            entity.Property(e => e.Photo)
                .HasComment("圖片")
                .HasColumnName("photo");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Startdate)
                .HasMaxLength(20)
                .HasComment("開始日期(yyyy-mm-dd)")
                .HasColumnName("startdate");
            entity.Property(e => e.TagAry)
                .HasComment("多組標籤使用")
                .HasColumnName("tag_ary");
            entity.Property(e => e.TagSid)
                .HasComment("標籤sid 做分類使用")
                .HasColumnName("tag_sid");
            entity.Property(e => e.Title)
                .HasMaxLength(200)
                .HasComment("標題")
                .HasColumnName("title");
            entity.Property(e => e.Type)
                .HasMaxLength(255)
                .HasComment("certification:認證,release:校園投稿,activity:活動,International:國際,other:其他")
                .HasColumnName("type");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<CustomPlace>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_p__DDDFDD369CE0D242");

            entity.ToTable("custom_place", tb => tb.HasComment("使用者的服務單位"));

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Address)
                .HasMaxLength(100)
                .HasComment("地址")
                .HasColumnName("address");
            entity.Property(e => e.AreaSid)
                .HasComment("地區sid")
                .HasColumnName("area_sid");
            entity.Property(e => e.CitySid)
                .HasComment("縣市sid")
                .HasColumnName("city_sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Enddate)
                .HasMaxLength(20)
                .HasComment("下架時間")
                .HasColumnName("enddate");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.PlaceCname)
                .HasMaxLength(30)
                .HasComment("名稱")
                .HasColumnName("place_cname");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Startdate)
                .HasMaxLength(20)
                .HasComment("上架時間")
                .HasColumnName("startdate");
            entity.Property(e => e.Tel)
                .HasComment("電話")
                .HasColumnName("tel");
            entity.Property(e => e.Type)
                .HasMaxLength(255)
                .HasComment("school:生態學校,epa:環保人員,tutor:輔導人員")
                .HasColumnName("type");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<CustomQuestion>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_q__DDDFDD3628433D2E");

            entity.ToTable("custom_question", tb => tb.HasComment("題目；用於建立題目跟子題目"));

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.IsRenewTemp)
                .HasComment("臨時欄位，對應原 is_renew，用於資料遷移")
                .HasColumnName("is_renew_temp");
            entity.Property(e => e.IsUse)
                .HasComment("是否啟用；1:使用、0:不使用")
                .HasColumnName("is_use");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.ParentSid)
                .HasComment("子題目sid；如：生態團隊下的學生名單")
                .HasColumnName("parent_sid");
            entity.Property(e => e.QuestionTpl).HasColumnName("question_tpl");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Step)
                .HasComment("七大步驟中的第幾步驟")
                .HasColumnName("step");
            entity.Property(e => e.Title)
                .HasMaxLength(100)
                .HasComment("題目敘述")
                .HasColumnName("title");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<CustomReleaseEnTw>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_r__DDDFDD36BE94C5D0");

            entity.ToTable("custom_release_en_tw", tb => tb.HasComment("投稿 中英關聯表"));

            entity.HasIndex(e => e.ReleaseTwSid, "custom_release_en_tw_ibfk_1");

            entity.HasIndex(e => e.ReleaseEnSid, "custom_release_en_tw_ibfk_2");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.Passdate)
                .HasMaxLength(20)
                .HasComment("通過日期(yyyy-mm-dd)")
                .HasColumnName("passdate");
            entity.Property(e => e.ReleaseEnContent)
                .HasComment("英文投稿內容")
                .HasColumnName("release_en_content");
            entity.Property(e => e.ReleaseEnSid)
                .HasComment("英文投稿sid")
                .HasColumnName("release_en_sid");
            entity.Property(e => e.ReleaseOpinion)
                .HasComment("投稿審核意見")
                .HasColumnName("release_opinion");
            entity.Property(e => e.ReleaseTwContent)
                .HasComment("中文投稿內容")
                .HasColumnName("release_tw_content");
            entity.Property(e => e.ReleaseTwSid)
                .HasComment("中文投稿sid")
                .HasColumnName("release_tw_sid");
            entity.Property(e => e.Review)
                .HasMaxLength(255)
                .HasComment("審核狀態")
                .HasColumnName("review");
            entity.Property(e => e.Reviewdate)
                .HasMaxLength(20)
                .HasComment("送審日期(yyyy-mm-dd)")
                .HasColumnName("reviewdate");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");

            entity.HasOne(d => d.ReleaseEnS).WithMany(p => p.CustomReleaseEnTwReleaseEns)
                .HasForeignKey(d => d.ReleaseEnSid)
                .HasConstraintName("custom_release_en_tw_ibfk_2");

            entity.HasOne(d => d.ReleaseTwS).WithMany(p => p.CustomReleaseEnTwReleaseTws)
                .HasForeignKey(d => d.ReleaseTwSid)
                .HasConstraintName("custom_release_en_tw_ibfk_1");
        });

        modelBuilder.Entity<CustomReleasePhoto>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_r__DDDFDD368368BEAB");

            entity.ToTable("custom_release_photo", tb => tb.HasComment("投稿 中英關聯表"));

            entity.HasIndex(e => e.ReleaseSid, "custom_release_photo_ibfk_1");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Description)
                .HasComment("照片說明")
                .HasColumnName("description");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.Photo)
                .HasComment("投稿照片")
                .HasColumnName("photo");
            entity.Property(e => e.ReleaseSid).HasColumnName("release_sid");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");

            entity.HasOne(d => d.ReleaseS).WithMany(p => p.CustomReleasePhotos)
                .HasForeignKey(d => d.ReleaseSid)
                .HasConstraintName("custom_release_photo_ibfk_1");
        });

        modelBuilder.Entity<CustomSchoolImport>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_s__DDDFDD361DE66B5B");

            entity.ToTable("custom_school_import", tb => tb.HasComment("紀錄學校的員工數量及各年級學生數量"));

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Address)
                .HasMaxLength(100)
                .HasColumnName("address");
            entity.Property(e => e.AreaSid).HasColumnName("area_sid");
            entity.Property(e => e.CitySid).HasColumnName("city_sid");
            entity.Property(e => e.Cname)
                .HasMaxLength(20)
                .HasColumnName("cname");
            entity.Property(e => e.Code)
                .HasMaxLength(12)
                .HasColumnName("code");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Tel)
                .HasMaxLength(20)
                .HasColumnName("tel");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
            entity.Property(e => e.Url).HasColumnName("url");
        });

        modelBuilder.Entity<CustomSchoolPrincipal>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_s__DDDFDD36740FF294");

            entity.ToTable("custom_school_principal", tb => tb.HasComment("學校校長基本資料"));

            entity.HasIndex(e => e.MemberSid, "custom_school_principal_ibfk_1");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.MemberSid)
                .HasComment("使用者sid")
                .HasColumnName("member_sid");
            entity.Property(e => e.PrincipalCname)
                .HasMaxLength(20)
                .HasComment("校長名稱(中文)")
                .HasColumnName("principal_cname");
            entity.Property(e => e.PrincipalCnameEn)
                .HasMaxLength(50)
                .HasComment("校長名稱(英文)")
                .HasColumnName("principal_cname_en");
            entity.Property(e => e.PrincipalEmail)
                .HasMaxLength(50)
                .HasComment("校長信箱")
                .HasColumnName("principal_email");
            entity.Property(e => e.PrincipalPhone)
                .HasMaxLength(20)
                .HasComment("校長手機")
                .HasColumnName("principal_phone");
            entity.Property(e => e.PrincipalTel)
                .HasMaxLength(20)
                .HasComment("校長電話")
                .HasColumnName("principal_tel");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");

            entity.HasOne(d => d.MemberS).WithMany(p => p.CustomSchoolPrincipals)
                .HasForeignKey(d => d.MemberSid)
                .HasConstraintName("custom_school_principal_ibfk_1");
        });

        modelBuilder.Entity<CustomSchoolStatistic>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_s__DDDFDD36CCD5CC84");

            entity.ToTable("custom_school_statistics", tb => tb.HasComment("紀錄學校的員工數量及各年級學生數量"));

            entity.HasIndex(e => e.MemberSid, "custom_school_statistics_ibfk_1");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Elementary1)
                .HasComment("國小1年級")
                .HasColumnName("elementary1");
            entity.Property(e => e.Elementary2)
                .HasComment("國小2年級")
                .HasColumnName("elementary2");
            entity.Property(e => e.Elementary3)
                .HasComment("國小3年級")
                .HasColumnName("elementary3");
            entity.Property(e => e.Elementary4)
                .HasComment("國小4年級")
                .HasColumnName("elementary4");
            entity.Property(e => e.Elementary5)
                .HasComment("國小5年級")
                .HasColumnName("elementary5");
            entity.Property(e => e.Elementary6)
                .HasComment("國小6年級")
                .HasColumnName("elementary6");
            entity.Property(e => e.Hight10)
                .HasComment("高中1年級")
                .HasColumnName("hight10");
            entity.Property(e => e.Hight11)
                .HasComment("高中2年級")
                .HasColumnName("hight11");
            entity.Property(e => e.Hight12)
                .HasComment("高中3年級")
                .HasColumnName("hight12");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.MemberSid)
                .HasComment("使用者sid")
                .HasColumnName("member_sid");
            entity.Property(e => e.Middle7)
                .HasComment("國中1年級")
                .HasColumnName("middle7");
            entity.Property(e => e.Middle8)
                .HasComment("國中2年級")
                .HasColumnName("middle8");
            entity.Property(e => e.Middle9)
                .HasComment("國中3年級")
                .HasColumnName("middle9");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.StaffTotal)
                .HasComment("校內員工總數")
                .HasColumnName("staff_total");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
            entity.Property(e => e.WriteDate)
                .HasMaxLength(20)
                .HasColumnName("write_date");

            entity.HasOne(d => d.MemberS).WithMany(p => p.CustomSchoolStatistics)
                .HasForeignKey(d => d.MemberSid)
                .HasConstraintName("custom_school_statistics_ibfk_1");
        });

        modelBuilder.Entity<CustomSocialAgency>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_s__DDDFDD36D2E5F18B");

            entity.ToTable("custom_social_agency");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasComment("資料編號")
                .HasColumnName("sid");
            entity.Property(e => e.AchievementList)
                .HasComment("實績 (\\r\\n換行)")
                .HasColumnName("achievement_list");
            entity.Property(e => e.ContactInfo)
                .HasMaxLength(200)
                .HasComment("聯絡資訊")
                .HasColumnName("contact_info");
            entity.Property(e => e.Createdate)
                .HasComment("建立時間 (timestamp)")
                .HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasComment("建立人IP資訊")
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasComment("建立人")
                .HasColumnName("createuser");
            entity.Property(e => e.Description)
                .HasMaxLength(1000)
                .HasComment("描述")
                .HasColumnName("description");
            entity.Property(e => e.FrontImg)
                .HasMaxLength(255)
                .HasComment("封面圖片檔案名稱")
                .HasColumnName("front_img");
            entity.Property(e => e.SupportSchoolItemList)
                .HasComment("協助學校內容 (\\r\\n換行)")
                .HasColumnName("support_school_item_list");
            entity.Property(e => e.Title)
                .HasMaxLength(30)
                .HasComment("名稱")
                .HasColumnName("title");
            entity.Property(e => e.Updatedate)
                .HasComment("最後更新時間 (timestamp)")
                .HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasComment("更新人IP資訊")
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasComment("最後更新人")
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<CustomSocialAgencyToTag>(entity =>
        {
            entity.HasKey(e => new { e.SocialAgencySid, e.TagSid }).HasName("PK__custom_s__9A08C5D36697D2F6");

            entity.ToTable("custom_social_agency_to_tag");

            entity.Property(e => e.SocialAgencySid).HasColumnName("social_agency_sid");
            entity.Property(e => e.TagSid).HasColumnName("tag_sid");
        });

        modelBuilder.Entity<CustomTag>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__custom_t__DDDFDD360C9A0ED0");

            entity.ToTable("custom_tag", tb => tb.HasComment("文章分類"));

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Cname)
                .HasMaxLength(30)
                .HasComment("名稱")
                .HasColumnName("cname");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Enddate)
                .HasMaxLength(20)
                .HasComment("下架時間")
                .HasColumnName("enddate");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.Photo)
                .HasComment("icon")
                .HasColumnName("photo");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.ShowStyle)
                .HasMaxLength(10)
                .HasComment("模板、樣式")
                .HasColumnName("show_style");
            entity.Property(e => e.Startdate)
                .HasMaxLength(20)
                .HasComment("上架時間")
                .HasColumnName("startdate");
            entity.Property(e => e.Type)
                .HasMaxLength(255)
                .HasComment("news:最新消息,video:精選影片,about:簡介,execute:執行方式,certification:認證介紹,fqa:常見問題,release:校園投稿說明,file_dl:檔案下載,related:友善連結,tutor:輔導人員")
                .HasColumnName("type");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<LineAction>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__line_act__DDDFDD36F0686031");

            entity.ToTable("line_action", tb => tb.HasComment("相關關鍵字，對應哪些function"));

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.FunctionName)
                .HasMaxLength(255)
                .HasComment("對應要執行的php function")
                .HasColumnName("function_name");
            entity.Property(e => e.Keyword)
                .HasMaxLength(255)
                .HasComment("接收到的line訊息是什麼關鍵字")
                .HasColumnName("keyword");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.SourceType)
                .HasMaxLength(10)
                .HasComment("接收來源,對應line API的 user,room,group")
                .HasColumnName("source_type");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<LineActionReg>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__line_act__DDDFDD3677774936");

            entity.ToTable("line_action_reg", tb => tb.HasComment("哪些使用者被登記相對應的action"));

            entity.HasIndex(e => e.ActionSid, "action_sid");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.ActionSid)
                .HasComment("對應line_action資料表的sid")
                .HasColumnName("action_sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.SourceId)
                .HasMaxLength(64)
                .HasComment("登記從line傳過來的source_id")
                .HasColumnName("source_id");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");

            entity.HasOne(d => d.ActionS).WithMany(p => p.LineActionRegs)
                .HasForeignKey(d => d.ActionSid)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("line_action_reg_ibfk_1");
        });

        modelBuilder.Entity<LineLog>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__line_log__DDDFDD36995BD5B2");

            entity.ToTable("line_log", tb => tb.HasComment("記錄從line傳過來的訊息"));

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Date)
                .HasComment("log的日期，預設為寫入資料當下的時間")
                .HasColumnName("date");
            entity.Property(e => e.Log)
                .HasComment("要記錄的內容，大部分都是整包line傳過來的http body param")
                .HasColumnName("log");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<SimpleDtoSetting>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__simple_d__DDDFDD36F46F8C1E");

            entity.ToTable("simple_dto_setting", tb => tb.HasComment("給簡易CRUD用的，記錄dto的變數和各個欄位相對應data source (因為大部分dto都是直接對應資料表欄位，所以也可以看成是對應db table columms)"));

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.FileImageHeight)
                .HasComment("圖片上傳時裁切設定的高 (若無則使用者自訂)")
                .HasColumnName("file_image_height");
            entity.Property(e => e.FileImageQuality)
                .HasComment("圖片上傳時的限制數量")
                .HasColumnName("file_image_quality");
            entity.Property(e => e.FileImageWidth)
                .HasComment("圖片上傳時裁切設定的寬 (若無則使用者自訂)")
                .HasColumnName("file_image_width");
            entity.Property(e => e.FileUploadType)
                .HasMaxLength(128)
                .HasComment("檔案上傳限定的副檔名")
                .HasColumnName("file_upload_type");
            entity.Property(e => e.GridColCss)
                .HasMaxLength(32)
                .HasComment("使用grid system，自定義class樣式")
                .HasColumnName("grid_col_css");
            entity.Property(e => e.InputSourceTag)
                .HasMaxLength(32)
                .HasComment("如果var_type是input_source，程式會抓對應simple_input_source這張表的tag")
                .HasColumnName("input_source_tag");
            entity.Property(e => e.JoinWithAs)
                .HasMaxLength(32)
                .HasComment("要join的table as 名稱")
                .HasColumnName("join_with_as");
            entity.Property(e => e.JoinWithVarName)
                .HasMaxLength(32)
                .HasComment("join後主要對應的欄位")
                .HasColumnName("join_with_var_name");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.ModelSid)
                .HasComment("對應simple_model_setting的sid")
                .HasColumnName("model_sid");
            entity.Property(e => e.ReadOnly)
                .HasComment("0 = 可讀寫(預設)，1 = 唯讀(依然會送post出去)，2 = 禁止寫入(不會送post出去)")
                .HasColumnName("read_only");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.ShowOnList)
                .HasComment("是否在列表顯示")
                .HasColumnName("show_on_list");
            entity.Property(e => e.TdStyle)
                .HasMaxLength(255)
                .HasComment("在列表內可以設定個別的style")
                .HasColumnName("td_style");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
            entity.Property(e => e.VarCname)
                .HasMaxLength(32)
                .HasComment("此變數的中文名稱")
                .HasColumnName("var_cname");
            entity.Property(e => e.VarDefaultValue)
                .HasMaxLength(255)
                .HasComment("變數預設值")
                .HasColumnName("var_default_value");
            entity.Property(e => e.VarDescription)
                .HasMaxLength(128)
                .HasComment("描述此變數的作用")
                .HasColumnName("var_description");
            entity.Property(e => e.VarFromAs)
                .HasMaxLength(32)
                .HasComment("此變數從哪一張表來")
                .HasColumnName("var_from_as");
            entity.Property(e => e.VarName)
                .HasMaxLength(32)
                .HasComment("dto的變數名稱 (html 的 name 會參考此而產生)")
                .HasColumnName("var_name");
            entity.Property(e => e.VarType)
                .HasMaxLength(255)
                .HasComment("此變數應該會存什麼，字串 text，大量字串 textarea，數字 number，檔案上傳 (存檔案名稱) file，圖片上傳 (存檔案名稱) file_image，從別的資料來源存入 input_source，日期 date，時間日期 datetime")
                .HasColumnName("var_type");
        });

        modelBuilder.Entity<SimpleInputSource>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__simple_i__DDDFDD362F9E1B7E");

            entity.ToTable("simple_input_source", tb => tb.HasComment("給簡易CRUD用的，當input欄位包含select需要有一些設定值時，可以使用這邊的設定"));

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Cname)
                .HasMaxLength(255)
                .HasComment("顯示的名稱")
                .HasColumnName("cname");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.HtmlTag)
                .HasMaxLength(16)
                .HasComment("對應html的標籤")
                .HasColumnName("html_tag");
            entity.Property(e => e.HtmlType)
                .HasMaxLength(16)
                .HasComment("對應html的type")
                .HasColumnName("html_type");
            entity.Property(e => e.HtmlValue)
                .HasMaxLength(255)
                .HasComment("對應html的value")
                .HasColumnName("html_value");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.SimpleTag)
                .HasMaxLength(32)
                .HasComment("標記讓程式知道要抓誰的tag")
                .HasColumnName("simple_tag");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<SimpleModelJoinSetting>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__simple_m__DDDFDD36790E8437");

            entity.ToTable("simple_model_join_setting", tb => tb.HasComment("給簡易CRUD用的，記錄Model所要join的table相關設定"));

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.JoinCname)
                .HasMaxLength(32)
                .HasComment("中文名稱")
                .HasColumnName("join_cname");
            entity.Property(e => e.JoinDirection)
                .HasMaxLength(255)
                .HasComment("join的方式")
                .HasColumnName("join_direction");
            entity.Property(e => e.JoinFromTable)
                .HasMaxLength(32)
                .HasComment("要from的table")
                .HasColumnName("join_from_table");
            entity.Property(e => e.JoinLeftVar)
                .HasMaxLength(32)
                .HasComment("要join的table對應的變數名稱_from那張表")
                .HasColumnName("join_left_var");
            entity.Property(e => e.JoinRightVar)
                .HasMaxLength(32)
                .HasComment("要join的table對應的變數名稱_被join的表")
                .HasColumnName("join_right_var");
            entity.Property(e => e.JoinWithAs)
                .HasMaxLength(32)
                .HasComment("要join的table as 名稱")
                .HasColumnName("join_with_as");
            entity.Property(e => e.JoinWithTable)
                .HasMaxLength(32)
                .HasComment("要join的table")
                .HasColumnName("join_with_table");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.ModelSid)
                .HasComment("對應simple_model_setting的sid")
                .HasColumnName("model_sid");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<SimpleModelSetting>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__simple_m__DDDFDD363B4B22DD");

            entity.ToTable("simple_model_setting", tb => tb.HasComment("給簡易CRUD用的，記錄Model和針對這個Model的相關設定 (因為大部分Model都是直接對應資料表，所以也可以看成是對應db table)"));

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.AddBookmark)
                .HasMaxLength(255)
                .HasComment("是否使用文字編輯器 'single'使用單頁籤，'mulit'使用多頁籤，'no'不使用")
                .HasColumnName("add_bookmark");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.ModelName)
                .HasMaxLength(64)
                .HasComment("對應Model名稱")
                .HasColumnName("model_name");
            entity.Property(e => e.ModelPath)
                .HasMaxLength(16)
                .HasComment("此Model的路徑")
                .HasColumnName("model_path");
            entity.Property(e => e.ModelPk)
                .HasMaxLength(32)
                .HasComment("使用delete或者update的時候，所使用的where value (大部分都用sid即可)")
                .HasColumnName("model_pk");
            entity.Property(e => e.OtherPost)
                .HasComment("其他post按鈕")
                .HasColumnName("other_post");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.ShowName)
                .HasMaxLength(16)
                .HasComment("此頁面的名稱 (麵包屑的名稱)")
                .HasColumnName("show_name");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
            entity.Property(e => e.WhereFirst)
                .HasMaxLength(128)
                .HasComment("呼叫ac_model->all以前，先呼叫where，where的內容放這")
                .HasColumnName("where_first");
        });

        modelBuilder.Entity<SysAccount>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__sys_acco__DDDFDD363E500496");

            entity.ToTable("sys_account");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Account)
                .HasMaxLength(50)
                .HasColumnName("account");
            entity.Property(e => e.Address)
                .HasMaxLength(100)
                .HasColumnName("address");
            entity.Property(e => e.AreaSid).HasColumnName("area_sid");
            entity.Property(e => e.Birthday)
                .HasMaxLength(20)
                .HasColumnName("birthday");
            entity.Property(e => e.CitySid).HasColumnName("city_sid");
            entity.Property(e => e.Cname)
                .HasMaxLength(20)
                .HasColumnName("cname");
            entity.Property(e => e.CnameEn)
                .HasMaxLength(50)
                .HasColumnName("cname_en");
            entity.Property(e => e.CompanySid).HasColumnName("company_sid");
            entity.Property(e => e.CompanyTitleSid).HasColumnName("company_title_sid");
            entity.Property(e => e.ContactName)
                .HasMaxLength(20)
                .HasColumnName("contact_name");
            entity.Property(e => e.ContactPhone)
                .HasMaxLength(20)
                .HasColumnName("contact_phone");
            entity.Property(e => e.ContactRelationship)
                .HasMaxLength(20)
                .HasColumnName("contact_relationship");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Departuredate)
                .HasMaxLength(20)
                .HasColumnName("departuredate");
            entity.Property(e => e.Dutydate)
                .HasMaxLength(20)
                .HasColumnName("dutydate");
            entity.Property(e => e.Email)
                .HasMaxLength(150)
                .HasColumnName("email");
            entity.Property(e => e.GroupsSid).HasColumnName("groups_sid");
            entity.Property(e => e.Isuse).HasColumnName("isuse");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.Password).HasColumnName("password");
            entity.Property(e => e.PasswordSalt)
                .HasMaxLength(50)
                .HasColumnName("password_salt");
            entity.Property(e => e.Phone)
                .HasMaxLength(20)
                .HasColumnName("phone");
            entity.Property(e => e.Picinfo)
                .HasMaxLength(200)
                .HasColumnName("picinfo");
            entity.Property(e => e.PostCode)
                .HasMaxLength(10)
                .HasColumnName("post_code");
            entity.Property(e => e.Remark).HasColumnName("remark");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Tel)
                .HasMaxLength(20)
                .HasColumnName("tel");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<SysAccountGroup>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__sys_acco__DDDFDD36A1F30CB0");

            entity.ToTable("sys_account_groups");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Enddate)
                .HasMaxLength(20)
                .HasColumnName("enddate");
            entity.Property(e => e.GroupSid)
                .HasComment("對應的角色群組")
                .HasColumnName("group_sid");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.OriginalCompanySid)
                .HasComment("原始的單位 (當個人移動到不同單位時，例如調職，用此欄位判斷原始單位，可用來判斷是否移除此權限)")
                .HasColumnName("original_company_sid");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Startdate)
                .HasMaxLength(20)
                .HasColumnName("startdate");
            entity.Property(e => e.TargetSid)
                .HasComment("授權目標")
                .HasColumnName("target_sid");
            entity.Property(e => e.Type)
                .HasMaxLength(1)
                .HasComment("授權方式：P=Person個人授權，U＝Unit單位授權(僅此單位)，D＝Department部門授權(此單位與向下單位都授權)")
                .HasColumnName("type");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<SysBannerpic>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__sys_bann__DDDFDD3647C082F5");

            entity.ToTable("sys_bannerpic");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Enddate)
                .HasMaxLength(20)
                .HasColumnName("enddate");
            entity.Property(e => e.Fileinfo)
                .HasMaxLength(255)
                .HasColumnName("fileinfo");
            entity.Property(e => e.Filename)
                .HasMaxLength(50)
                .HasColumnName("filename");
            entity.Property(e => e.Isblank).HasColumnName("isblank");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.Msg).HasColumnName("msg");
            entity.Property(e => e.ParentSid).HasColumnName("parent_sid");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Siteurl)
                .HasMaxLength(250)
                .HasColumnName("siteurl");
            entity.Property(e => e.Startdate)
                .HasMaxLength(20)
                .HasColumnName("startdate");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<SysCityarea>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__sys_city__DDDFDD36C27BB62F");

            entity.ToTable("sys_cityarea");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.AreaName)
                .HasMaxLength(20)
                .HasColumnName("area_name");
            entity.Property(e => e.AreaNameEn)
                .HasMaxLength(20)
                .HasColumnName("area_name_en");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Language)
                .HasMaxLength(10)
                .HasColumnName("language");
            entity.Property(e => e.ParentSid).HasColumnName("parent_sid");
            entity.Property(e => e.PostCode)
                .HasMaxLength(10)
                .HasColumnName("post_code");
            entity.Property(e => e.Remark)
                .HasMaxLength(100)
                .HasColumnName("remark");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<SysCompany>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__sys_comp__DDDFDD36D68B26D5");

            entity.ToTable("sys_company");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Address)
                .HasMaxLength(100)
                .HasColumnName("address");
            entity.Property(e => e.AddressEn)
                .HasMaxLength(200)
                .HasColumnName("address_en");
            entity.Property(e => e.AreaSid).HasColumnName("area_sid");
            entity.Property(e => e.Ceo)
                .HasMaxLength(30)
                .HasColumnName("ceo");
            entity.Property(e => e.CitySid).HasColumnName("city_sid");
            entity.Property(e => e.Cname)
                .HasMaxLength(50)
                .HasColumnName("cname");
            entity.Property(e => e.CnameEn)
                .HasMaxLength(100)
                .HasColumnName("cname_en");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Email)
                .HasMaxLength(150)
                .HasColumnName("email");
            entity.Property(e => e.Fax1)
                .HasMaxLength(20)
                .HasColumnName("fax1");
            entity.Property(e => e.Fax2)
                .HasMaxLength(20)
                .HasColumnName("fax2");
            entity.Property(e => e.Invoice)
                .HasMaxLength(50)
                .HasColumnName("invoice");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.LineChannelAccessToken)
                .HasMaxLength(255)
                .HasComment("line API 所需")
                .HasColumnName("line_Channel_access_token");
            entity.Property(e => e.LineChannelSecret)
                .HasMaxLength(64)
                .HasComment("line API 所需")
                .HasColumnName("line_Channel_secret");
            entity.Property(e => e.Opendate)
                .HasMaxLength(20)
                .HasColumnName("opendate");
            entity.Property(e => e.ParentSid).HasColumnName("parent_sid");
            entity.Property(e => e.Phone)
                .HasMaxLength(30)
                .HasColumnName("phone");
            entity.Property(e => e.PostCode)
                .HasMaxLength(10)
                .HasColumnName("post_code");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.ServiceTime).HasColumnName("service_time");
            entity.Property(e => e.Tel)
                .HasMaxLength(20)
                .HasColumnName("tel");
            entity.Property(e => e.TelEn)
                .HasMaxLength(20)
                .HasColumnName("tel_en");
            entity.Property(e => e.TelExt)
                .HasMaxLength(5)
                .HasColumnName("tel_ext");
            entity.Property(e => e.TelService)
                .HasMaxLength(50)
                .HasColumnName("tel_service");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
            entity.Property(e => e.Vatnumber)
                .HasMaxLength(15)
                .HasColumnName("vatnumber");
        });

        modelBuilder.Entity<SysCompanyJobTitle>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__sys_comp__DDDFDD36710EEBF1");

            entity.ToTable("sys_company_job_title");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Cname)
                .HasMaxLength(30)
                .HasColumnName("cname");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Enddate)
                .HasMaxLength(20)
                .HasColumnName("enddate");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.ParentSid).HasColumnName("parent_sid");
            entity.Property(e => e.Remark)
                .HasMaxLength(100)
                .HasColumnName("remark");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Startdate)
                .HasMaxLength(20)
                .HasColumnName("startdate");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<SysFilesStore>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__sys_file__DDDFDD367014A224");

            entity.ToTable("sys_files_store", tb => tb.HasComment("將上傳後的檔案集中管理，有需要的功能可以自己開表關聯這張表。也為了未來將檔案集中管理，例如A和B兩個使用者上傳一模一樣的檔案，那就可以只存留一份檔案，然後用關聯表把他關聯起來。"));

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.ActionSigh)
                .HasMaxLength(255)
                .HasComment("標記預計要做的動作 (檔案上傳後雖然已經在server內，但只有在使用者確認儲存後才會實際關聯需要的表or刪掉他) (’save’=儲存,’delete’=刪除)")
                .HasColumnName("action_sigh");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.FileExt)
                .HasMaxLength(16)
                .HasComment("副檔名")
                .HasColumnName("file_ext");
            entity.Property(e => e.FileHash)
                .HasMaxLength(32)
                .IsFixedLength()
                .HasComment("檔案的 hash，使用 MD5")
                .HasColumnName("file_hash");
            entity.Property(e => e.FilePath)
                .HasMaxLength(255)
                .HasComment("檔案實際儲存路徑")
                .HasColumnName("file_path");
            entity.Property(e => e.Hits).HasColumnName("hits");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.Name)
                .HasMaxLength(255)
                .HasComment("檔案實際存在server內的名稱")
                .HasColumnName("name");
            entity.Property(e => e.Remark)
                .HasComment("被哪個功能認領了 (只是用來記錄，未來要刪除不必要檔案時，方便尋找還有沒有人要使用這個檔案)")
                .HasColumnName("remark");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Sigh)
                .HasMaxLength(255)
                .HasComment("此檔案是甚麼狀態 (’save’=已按下確認儲存,’temporary’=未按下確認儲存,’same’=有人上傳過一模一樣的檔案並儲存，不能隨意刪除)")
                .HasColumnName("sigh");
            entity.Property(e => e.Size)
                .HasComment("為檔案大小，單位為Byte")
                .HasColumnName("size");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
            entity.Property(e => e.UploadFrom)
                .HasMaxLength(16)
                .HasComment("可以分辨從前台上傳還是後台上傳")
                .HasColumnName("upload_from");
            entity.Property(e => e.UploadToken)
                .HasMaxLength(32)
                .IsFixedLength()
                .HasComment("這個上傳的檔案屬於誰的 (用一個token標記，等使用者真的按下確認後，才是真的確認上傳並儲存)")
                .HasColumnName("upload_token");
        });

        modelBuilder.Entity<SysGroup>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__sys_grou__DDDFDD3648FA436E");

            entity.ToTable("sys_groups");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Cname)
                .HasMaxLength(50)
                .HasColumnName("cname");
            entity.Property(e => e.CompanySid).HasColumnName("company_sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.Remark).HasColumnName("remark");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<SysGroupsRule>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__sys_grou__DDDFDD36EEAE35B4");

            entity.ToTable("sys_groups_rule");

            entity.HasIndex(e => e.GroupsSid, "groups_sid");

            entity.HasIndex(e => e.RuleSid, "rule_sid");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.C).HasColumnName("c");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.D).HasColumnName("d");
            entity.Property(e => e.GroupsSid).HasColumnName("groups_sid");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.R).HasColumnName("r");
            entity.Property(e => e.RuleSid).HasColumnName("rule_sid");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.U).HasColumnName("u");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<SysLanguageDatum>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__sys_lang__DDDFDD36924CD70B");

            entity.ToTable("sys_language_data");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Cn).HasColumnName("cn");
            entity.Property(e => e.CreatePostParam).HasColumnName("create_post_param");
            entity.Property(e => e.CreateUrlPath)
                .HasMaxLength(128)
                .HasColumnName("create_url_path");
            entity.Property(e => e.En).HasColumnName("en");
            entity.Property(e => e.KeyWord).HasColumnName("key_word");
            entity.Property(e => e.PointPath)
                .HasMaxLength(128)
                .HasColumnName("point_path");
            entity.Property(e => e.ZhTw).HasColumnName("zh_tw");
        });

        modelBuilder.Entity<SysLoginProcess>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__sys_logi__DDDFDD36845FE1EF");

            entity.ToTable("sys_login_process", tb => tb.HasComment("登錄驗證"));

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Ip)
                .HasMaxLength(20)
                .HasComment("ip")
                .HasColumnName("ip");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Times)
                .HasComment("次數")
                .HasColumnName("times");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
            entity.Property(e => e.Url)
                .HasMaxLength(255)
                .HasComment("連結")
                .HasColumnName("url");
        });

        modelBuilder.Entity<SysMailLog>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__sys_mail__DDDFDD3676EA14A9");

            entity.ToTable("sys_mail_log", tb => tb.HasComment("寄信log"));

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.LogInfo).HasColumnName("log_info");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<SysMailSmtp>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__sys_mail__DDDFDD36ED893793");

            entity.ToTable("sys_mail_smtp", tb => tb.HasComment("寄信SMTP設定"));

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.Mailpath)
                .HasMaxLength(50)
                .HasComment("寄信指令位置")
                .HasColumnName("mailpath");
            entity.Property(e => e.Protocol)
                .HasMaxLength(50)
                .HasComment("寄信模式")
                .HasColumnName("protocol");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.SmtpCrypto)
                .HasMaxLength(10)
                .HasComment("'' or 'tls' or 'ssl'")
                .HasColumnName("smtp_crypto");
            entity.Property(e => e.SmtpHost)
                .HasMaxLength(50)
                .HasComment("host")
                .HasColumnName("smtp_host");
            entity.Property(e => e.SmtpPass)
                .HasMaxLength(50)
                .HasComment("管理者寄信密碼")
                .HasColumnName("smtp_pass");
            entity.Property(e => e.SmtpPort)
                .HasMaxLength(10)
                .HasComment("smtp_port")
                .HasColumnName("smtp_port");
            entity.Property(e => e.SmtpUser)
                .HasMaxLength(50)
                .HasComment("管理者信箱")
                .HasColumnName("smtp_user");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<SysMailinfo>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__sys_mail__DDDFDD3628487BAD");

            entity.ToTable("sys_mailinfo");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Addmail)
                .HasMaxLength(50)
                .HasColumnName("addmail");
            entity.Property(e => e.Addname)
                .HasMaxLength(50)
                .HasColumnName("addname");
            entity.Property(e => e.ClassificationSid).HasColumnName("classification_sid");
            entity.Property(e => e.Cname)
                .HasMaxLength(50)
                .HasColumnName("cname");
            entity.Property(e => e.Content)
                .HasComment("email內文 (實際內文的變數用兩個大括號 ex: {{title}} ，讓工程師自己去取代)")
                .HasColumnName("content");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Enddate)
                .HasMaxLength(20)
                .HasColumnName("enddate");
            entity.Property(e => e.Frommail)
                .HasMaxLength(50)
                .HasColumnName("frommail");
            entity.Property(e => e.Fromname)
                .HasMaxLength(50)
                .HasColumnName("fromname");
            entity.Property(e => e.Isbcc).HasColumnName("isbcc");
            entity.Property(e => e.Isrepeat).HasColumnName("isrepeat");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Siteurl)
                .HasMaxLength(200)
                .HasColumnName("siteurl");
            entity.Property(e => e.Startdate)
                .HasMaxLength(20)
                .HasColumnName("startdate");
            entity.Property(e => e.StoreName)
                .HasMaxLength(50)
                .HasColumnName("store_name");
            entity.Property(e => e.Subject)
                .HasMaxLength(50)
                .HasColumnName("subject");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<SysMetadatum>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__sys_meta__DDDFDD363D101659");

            entity.ToTable("sys_metadata");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Enddate)
                .HasMaxLength(20)
                .HasColumnName("enddate");
            entity.Property(e => e.FbLink)
                .HasMaxLength(200)
                .HasComment("fb連結")
                .HasColumnName("fb_link");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.LineLink)
                .HasMaxLength(200)
                .HasComment("line連結")
                .HasColumnName("line_link");
            entity.Property(e => e.ManualViewCount)
                .HasComment("自填入瀏覽人數")
                .HasColumnName("manual_view_count");
            entity.Property(e => e.Metaauthor)
                .HasMaxLength(100)
                .HasColumnName("metaauthor");
            entity.Property(e => e.Metaauthoremail)
                .HasMaxLength(150)
                .HasColumnName("metaauthoremail");
            entity.Property(e => e.Metaauthorurl)
                .HasMaxLength(150)
                .HasColumnName("metaauthorurl");
            entity.Property(e => e.MetacacheControl)
                .HasMaxLength(50)
                .HasColumnName("metacache_control");
            entity.Property(e => e.Metacompany)
                .HasMaxLength(200)
                .HasColumnName("metacompany");
            entity.Property(e => e.Metacopyright)
                .HasMaxLength(200)
                .HasColumnName("metacopyright");
            entity.Property(e => e.Metacreationdate)
                .HasMaxLength(100)
                .HasColumnName("metacreationdate");
            entity.Property(e => e.Metadescription).HasColumnName("metadescription");
            entity.Property(e => e.Metaexpires)
                .HasMaxLength(50)
                .HasColumnName("metaexpires");
            entity.Property(e => e.Metakeywords).HasColumnName("metakeywords");
            entity.Property(e => e.Metapragma)
                .HasMaxLength(50)
                .HasColumnName("metapragma");
            entity.Property(e => e.Metarating)
                .HasMaxLength(50)
                .HasColumnName("metarating");
            entity.Property(e => e.Metarevisitafter)
                .HasMaxLength(50)
                .HasColumnName("metarevisitafter");
            entity.Property(e => e.Metarobots)
                .HasMaxLength(50)
                .HasColumnName("metarobots");
            entity.Property(e => e.SearchKeyword)
                .HasMaxLength(50)
                .HasComment("搜尋提示")
                .HasColumnName("search_keyword");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Sitetitle)
                .HasMaxLength(200)
                .HasColumnName("sitetitle");
            entity.Property(e => e.Siteurl)
                .HasMaxLength(200)
                .HasColumnName("siteurl");
            entity.Property(e => e.Startdate)
                .HasMaxLength(20)
                .HasColumnName("startdate");
            entity.Property(e => e.Sysico)
                .HasMaxLength(50)
                .HasColumnName("sysico");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<SysModule>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__sys_modu__DDDFDD36010C93EC");

            entity.ToTable("sys_module");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.ModuleIcons)
                .HasMaxLength(20)
                .HasColumnName("module_icons");
            entity.Property(e => e.ModuleName)
                .HasMaxLength(50)
                .HasColumnName("module_name");
            entity.Property(e => e.ModuleType).HasColumnName("module_type");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<SysRule>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__sys_rule__DDDFDD36E1889BB1");

            entity.ToTable("sys_rule");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.ModuleSid).HasColumnName("module_sid");
            entity.Property(e => e.ParentSid).HasColumnName("parent_sid");
            entity.Property(e => e.RuleName)
                .HasMaxLength(50)
                .HasColumnName("rule_name");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
            entity.Property(e => e.Url)
                .HasMaxLength(200)
                .HasColumnName("url");
        });

        modelBuilder.Entity<SysSerialNo>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__sys_seri__DDDFDD36B5CB2001");

            entity.ToTable("sys_serial_no");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.NoType)
                .HasMaxLength(50)
                .HasColumnName("no_type");
            entity.Property(e => e.SeqNo).HasColumnName("seq_no");
            entity.Property(e => e.YearMonthDate)
                .HasMaxLength(15)
                .HasColumnName("year_month_date");
        });

        modelBuilder.Entity<SysSysinfo>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__sys_sysi__DDDFDD366AC3AFC7");

            entity.ToTable("sys_sysinfo");

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Bgpic)
                .HasMaxLength(50)
                .HasColumnName("bgpic");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Httpson).HasColumnName("httpson");
            entity.Property(e => e.HttpsonEnd).HasColumnName("httpson_end");
            entity.Property(e => e.HttpsonFront).HasColumnName("httpson_front");
            entity.Property(e => e.InvoiceApi).HasColumnName("invoice_api");
            entity.Property(e => e.Ipsource).HasColumnName("ipsource");
            entity.Property(e => e.IsTag).HasColumnName("is_tag");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.LineApi).HasColumnName("line_api");
            entity.Property(e => e.Metaauthor)
                .HasMaxLength(100)
                .HasColumnName("metaauthor");
            entity.Property(e => e.Metaauthoremail)
                .HasMaxLength(150)
                .HasColumnName("metaauthoremail");
            entity.Property(e => e.Metaauthorurl)
                .HasMaxLength(150)
                .HasColumnName("metaauthorurl");
            entity.Property(e => e.MetacacheControl)
                .HasMaxLength(50)
                .HasColumnName("metacache_control");
            entity.Property(e => e.Metacompany)
                .HasMaxLength(200)
                .HasColumnName("metacompany");
            entity.Property(e => e.Metacopyright)
                .HasMaxLength(200)
                .HasColumnName("metacopyright");
            entity.Property(e => e.Metacreationdate)
                .HasMaxLength(100)
                .HasColumnName("metacreationdate");
            entity.Property(e => e.Metadescription).HasColumnName("metadescription");
            entity.Property(e => e.Metaexpires)
                .HasMaxLength(50)
                .HasColumnName("metaexpires");
            entity.Property(e => e.Metakeywords).HasColumnName("metakeywords");
            entity.Property(e => e.Metapragma)
                .HasMaxLength(50)
                .HasColumnName("metapragma");
            entity.Property(e => e.Metarating)
                .HasMaxLength(50)
                .HasColumnName("metarating");
            entity.Property(e => e.Metarobots)
                .HasMaxLength(50)
                .HasColumnName("metarobots");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.ServiceToken).HasColumnName("service_token");
            entity.Property(e => e.Sitecompany)
                .HasMaxLength(100)
                .HasColumnName("sitecompany");
            entity.Property(e => e.Sitename)
                .HasMaxLength(100)
                .HasColumnName("sitename");
            entity.Property(e => e.Sitetitle)
                .HasMaxLength(200)
                .HasColumnName("sitetitle");
            entity.Property(e => e.Siteurl)
                .HasMaxLength(200)
                .HasColumnName("siteurl");
            entity.Property(e => e.SmsApi).HasColumnName("sms_api");
            entity.Property(e => e.Subsitename)
                .HasMaxLength(200)
                .HasColumnName("subsitename");
            entity.Property(e => e.Sysico)
                .HasMaxLength(50)
                .HasColumnName("sysico");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
            entity.Property(e => e.Useverify).HasColumnName("useverify");
            entity.Property(e => e.VerificationType)
                .HasMaxLength(20)
                .HasColumnName("verification_type");
        });

        modelBuilder.Entity<SysTemplate>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__sys_temp__DDDFDD363BD3F979");

            entity.ToTable("sys_template", tb => tb.HasComment("前台模板"));

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.ChildTemplateSid)
                .HasMaxLength(255)
                .HasComment("此模板底下可以放置其它模板，以逗號分隔sid，呼叫模板的順序由左到右")
                .HasColumnName("child_template_sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.NeedCaptcha)
                .HasComment("此頁是否需要驗證碼")
                .HasColumnName("need_captcha");
            entity.Property(e => e.RouterUrl)
                .HasMaxLength(255)
                .HasComment("如果MVC的Router找不到對應的controller，就會導向到front controller，讓controller參考此欄位show出對應的template")
                .HasColumnName("router_url");
            entity.Property(e => e.Sequence)
                .HasComment("show template 的順序")
                .HasColumnName("sequence");
            entity.Property(e => e.TemplateCss)
                .HasComment("模板顯示時若針對某個頁面要調整css時，css內容可以放在這")
                .HasColumnName("template_css");
            entity.Property(e => e.TemplateFooterSid)
                .HasComment("此模板的footer")
                .HasColumnName("template_footer_sid");
            entity.Property(e => e.TemplateHeaderSid)
                .HasComment("此模板的header")
                .HasColumnName("template_header_sid");
            entity.Property(e => e.TemplateJs)
                .HasComment("模板顯示時若針對某個頁面要調整js時，js內容可以放在這")
                .HasColumnName("template_js");
            entity.Property(e => e.TemplateName)
                .HasMaxLength(64)
                .HasComment("前端設計師設計好的模板名稱")
                .HasColumnName("template_name");
            entity.Property(e => e.TemplateType)
                .HasMaxLength(255)
                .HasComment("此模板為header footer content哪一種類型")
                .HasColumnName("template_type");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
        });

        modelBuilder.Entity<SysTemplateParam>(entity =>
        {
            entity.HasKey(e => e.Sid).HasName("PK__sys_temp__DDDFDD367B25524E");

            entity.ToTable("sys_template_params", tb => tb.HasComment("前台模板"));

            entity.Property(e => e.Sid)
                .ValueGeneratedNever()
                .HasColumnName("sid");
            entity.Property(e => e.Createdate).HasColumnName("createdate");
            entity.Property(e => e.Createip)
                .HasMaxLength(45)
                .HasColumnName("createip");
            entity.Property(e => e.Createuser)
                .HasMaxLength(20)
                .HasColumnName("createuser");
            entity.Property(e => e.Lan)
                .HasMaxLength(10)
                .HasColumnName("lan");
            entity.Property(e => e.ModelMethod)
                .HasMaxLength(128)
                .HasComment("此變數的資料來源使用的method名稱")
                .HasColumnName("model_method");
            entity.Property(e => e.ModelMethodGet)
                .HasMaxLength(255)
                .HasComment("get 內容 (以逗號分隔)")
                .HasColumnName("model_method_get");
            entity.Property(e => e.ModelMethodParameter)
                .HasMaxLength(255)
                .HasComment("parameter 內容 (以逗號分隔，並對應$router的路徑，未對應到的傳入null，未有$開頭的傳入固定值)")
                .HasColumnName("model_method_parameter");
            entity.Property(e => e.ModelMethodPost)
                .HasMaxLength(255)
                .HasComment("post 內容 (以逗號分隔)")
                .HasColumnName("model_method_post");
            entity.Property(e => e.ModelName)
                .HasMaxLength(64)
                .HasComment("此變數的資料來源 (model 名稱)")
                .HasColumnName("model_name");
            entity.Property(e => e.ModelPath)
                .HasMaxLength(16)
                .HasComment("此變數的資料路徑 (model路徑)")
                .HasColumnName("model_path");
            entity.Property(e => e.ModelSendThisInput)
                .HasComment("是否把整個$this->input都送進去 (可以給param_to_dto用)")
                .HasColumnName("model_send_this_input");
            entity.Property(e => e.Sequence).HasColumnName("sequence");
            entity.Property(e => e.TemplateSid)
                .HasComment("對應template的sid")
                .HasColumnName("template_sid");
            entity.Property(e => e.Updatedate).HasColumnName("updatedate");
            entity.Property(e => e.Updateip)
                .HasMaxLength(45)
                .HasColumnName("updateip");
            entity.Property(e => e.Updateuser)
                .HasMaxLength(20)
                .HasColumnName("updateuser");
            entity.Property(e => e.UserCaptcha)
                .HasMaxLength(64)
                .HasComment("取得這個var以前，先抓取post過來的userCaptcha")
                .HasColumnName("userCaptcha");
            entity.Property(e => e.VarCname)
                .HasMaxLength(64)
                .HasComment("此變數的中文名稱")
                .HasColumnName("var_cname");
            entity.Property(e => e.VarDescription)
                .HasMaxLength(512)
                .HasComment("描述此變數的作用 (會吐什麼資料or資料格式...etc)")
                .HasColumnName("var_description");
            entity.Property(e => e.VarName)
                .HasMaxLength(64)
                .HasComment("對應模板內的變數名稱")
                .HasColumnName("var_name");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
