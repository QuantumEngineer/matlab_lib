function [foundfile] = FileSearch(findfile)
%Filesearch - Looks for files based on a prefix
%             Input: findfile - Prefix for File (string)
filesfolders = dir;
files = filesfolders(~([filesfolders.isdir])); 
for k = 1:1:length(files)
    filename = files(k).name;
    T = strncmpi((findfile),(filename),length(findfile));
    if T == 1
        foundfile = filename;
    end 
end 
