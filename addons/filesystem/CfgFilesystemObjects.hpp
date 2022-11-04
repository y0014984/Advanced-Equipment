
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
    class Tmp : AE3_FilesystemObject
    {
        type = "Folder";
        path = "/tmp";
        owner = "root";
        permissions[] = {{1, 1, 1}, {1, 1, 1}};
    };
    class Mnt : AE3_FilesystemObject
    {
        type = "Folder";
        path = "/mnt";
        owner = "root";
        permissions[] = {{1, 1, 1}, {1, 1, 0}};
    };
    class Var : AE3_FilesystemObject
    {
        type = "Folder";
        path = "/var";
        owner = "root";
        permissions[] = {{1, 1, 1}, {1, 1, 0}};
    };
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
    class Home : AE3_FilesystemObject
    {
        type = "Folder";
        path = "/home";
        owner = "root";
        permissions[] = {{1, 1, 1}, {1, 1, 0}};
    };
    class Sbin : AE3_FilesystemObject
    {
        type = "Folder";
        path = "/sbin";
        owner = "root";
        permissions[] = {{1, 1, 1}, {1, 1, 0}};
    };
    class Bin : AE3_FilesystemObject
    {
        type = "Folder";
        path = "/bin";
        owner = "root";
        permissions[] = {{1, 1, 1}, {1, 1, 0}};
    };
    class Root : AE3_FilesystemObject
    {
        type = "Folder";
        path = "/root";
        owner = "root";
        permissions[] = {{1, 1, 1}, {0, 0, 0}};
    };
    class Sys : AE3_FilesystemObject
    {
        type = "Folder";
        path = "/sys";
        owner = "root";
        permissions[] = {{1, 1, 1}, {1, 1, 0}};
    };
        class BatteryCapacity : AE3_FilesystemObject
        {
            type = "File";
            path = "/sys/battery/capacity";
            owner = "root";
            permissions[] = {{1, 1, 1}, {0, 1, 0}};
        };
};