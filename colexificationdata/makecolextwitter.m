langfile= '../freqdata/icesnowforms.txt';
[codes2 langcodes jk2 jk3]= textread(langfile,'%s%s%s%s', 'delimiter', ',');

% did replace on commas
outfiles = {'twittercolex'};

glottocodes = langcodes;
editd = nan*ones(size(glottocodes));

save(outfiles{1}, 'editd', 'glottocodes');
