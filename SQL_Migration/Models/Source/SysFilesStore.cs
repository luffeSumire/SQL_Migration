using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 將上傳後的檔案集中管理，有需要的功能可以自己開表關聯這張表。也為了未來將檔案集中管理，例如A和B兩個使用者上傳一模一樣的檔案，那就可以只存留一份檔案，然後用關聯表把他關聯起來。
/// </summary>
public partial class SysFilesStore
{
    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    public int? Sequence { get; set; }

    public int Hits { get; set; }

    public string? Lan { get; set; }

    /// <summary>
    /// 檔案實際存在server內的名稱
    /// </summary>
    public string? Name { get; set; }

    /// <summary>
    /// 副檔名
    /// </summary>
    public string? FileExt { get; set; }

    /// <summary>
    /// 為檔案大小，單位為Byte
    /// </summary>
    public long? Size { get; set; }

    /// <summary>
    /// 檔案的 hash，使用 MD5
    /// </summary>
    public string? FileHash { get; set; }

    /// <summary>
    /// 檔案實際儲存路徑
    /// </summary>
    public string? FilePath { get; set; }

    /// <summary>
    /// 被哪個功能認領了 (只是用來記錄，未來要刪除不必要檔案時，方便尋找還有沒有人要使用這個檔案)
    /// </summary>
    public string? Remark { get; set; }

    /// <summary>
    /// 這個上傳的檔案屬於誰的 (用一個token標記，等使用者真的按下確認後，才是真的確認上傳並儲存)
    /// </summary>
    public string? UploadToken { get; set; }

    /// <summary>
    /// 此檔案是甚麼狀態 (’save’=已按下確認儲存,’temporary’=未按下確認儲存,’same’=有人上傳過一模一樣的檔案並儲存，不能隨意刪除)
    /// </summary>
    public string? Sigh { get; set; }

    /// <summary>
    /// 標記預計要做的動作 (檔案上傳後雖然已經在server內，但只有在使用者確認儲存後才會實際關聯需要的表or刪掉他) (’save’=儲存,’delete’=刪除)
    /// </summary>
    public string? ActionSigh { get; set; }

    /// <summary>
    /// 可以分辨從前台上傳還是後台上傳
    /// </summary>
    public string? UploadFrom { get; set; }
}
