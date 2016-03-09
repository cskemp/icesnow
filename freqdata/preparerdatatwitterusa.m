
% use only languages that pass back-translation test?
cleanflag = 1;

% index of mean monthly temperature
climind = 6;
twclim = load('../langenvironmentdata/twitterclimateusa'); 

[rcodes c1 c2 c3 c4]= textread('allcountsusageoonly.txt','%d %d %d %d %u', 'delimiter', ' ');
rcodes = rcodes + 1;

[s,sind] = sort(rcodes);
rcodes = rcodes(sind); c1 = c1(sind); c2 = c2(sind); c3 = c3(sind); c4 = c4(sind);

rrprop = log((c1 + c2)./c3);
rrcounts = [c1+c2, c3];
rorigclim= twclim.climdata(:, climind);
rlabels = twclim.graphname;

save('rtwitterusa', 'rorigclim', 'rrprop', 'rrcounts', 'rfamcodes', 'rlabels')
