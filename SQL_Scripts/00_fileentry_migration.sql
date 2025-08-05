INSERT INTO EcoCampus_PreProduction.dbo.FileEntry
    (Id, Type, Path, OriginalFileName, OriginalExtension, FileName, Extension)
SELECT
    NEWID() AS Id,
    N'File' AS Type,
    '/uploads/' + file_path AS Path,
    name AS OriginalFileName,
    file_ext AS OriginalExtension,
    name AS FileName,
    file_ext AS Extension
FROM EcoCampus_Maria3.dbo.sys_files_store; 