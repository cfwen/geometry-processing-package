folders = {
    'algebra';
    'graphics';
    'io';
    'misc';
    'parameterization';
    'topology';
    };
option = struct('evalCode',false);
for i = 1:size(folders,1)
    folder = folders{i};
    mfiles = ls([folder '/*.m']);
    option.outputDir = ['html/' folder];
    for j = 1:size(mfiles,1)
        mfile = strtrim(mfiles(j,:));
        publish(mfile,option);
    end
end
%%
mfile = 'tutorial2.m';
option.outputDir = 'html/tutorial';
option.evalCode = true;
publish(mfile,option);

%%
mfile = 'contents.m';
option.outputDir = 'html/';
option.evalCode = false;
publish(mfile,option);