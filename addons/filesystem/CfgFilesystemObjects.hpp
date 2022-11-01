
class AE3_FilesystemObject
{
    type = "File"; // File or Folder
    path = "/tmp/example.txt"; // Absolute path
    content = ""; // file content - string or code
    owner = "root"; // name of owner
    permissions[] = {{1, 1, 1}, {0, 1, 0}}; // [[owner execute, owner read, owner write], [others execute, others read, others write]] true = 1 and 0 = false
};

class AE3_FilesystemObjects
{
    class Syslog : AE3_FilesystemObject
    {
        type = "File";
        path = "/var/log/syslog";
        content = "";
        owner = "root";
        permissions[] = {{1, 1, 1}, {0, 1, 0}};
    };
    class Authlog : AE3_FilesystemObject
    {
        type = "File";
        path = "/var/log/auth.log";
        content = "";
        owner = "root";
        permissions[] = {{1, 1, 1}, {0, 1, 0}};
    };
};