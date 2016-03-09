
% use only languages that pass back-translation test?
cleanflag = 1;

% index of mean monthly temperature
climind = 6;
twclim = load('../langenvironmentdata/twitterclimate'); 

allshort = textread('allcodes.txt','%s', 'delimiter', ' ');
alllong =  textread('longnames.txt','%s', 'delimiter', ' ');
[alll2 alllg j1 j2] = textread('icesnowforms.txt','%s %s %s %s', 'delimiter', ',');
allr = load('../mixedeffectsanalyses/rtwitterdata');

[rcodes c1 c2 c3 c4]= textread('allcounts.txt','%s %d %d %d %u', 'delimiter', ' ');
% because first number in c3 is large -- overflow issue 
disp('handcode first value')
c3(1) = 7630001193;
rprop = log((c1 + c2)./c3);
rcounts = [c1+c2, c3];

if cleanflag
  usecodes = textread('../freqdata/cleancodes.txt', '%s', 'delimiter', '');
else
  usecodes= textread('../freqdata/allcodeswithspaces.txt', '%s', 'delimiter', '');
end

[c ia ib] = intersect(rcodes, twclim.codes2); 

rcodes = rcodes(ia); rprop = rprop(ia); rcounts = rcounts(ia,:);
tempvar = twclim.climdata(ib, climind)/10;

[cc ia ib] = intersect(rcodes, usecodes);
rcodes = rcodes(ia); rprop = rprop(ia), rcounts = rcounts(ia,:); tempvar = tempvar(ia); 

% save file for R
% rcodes, tempvar, rprop 
%   merge with
%   alll2 alllg
%   then pull out climate from allr

[c ia ib] = intersect(rcodes, alll2);
subg = alllg(ib); 
rrprop = rprop(ia);
rrcounts = rcounts(ia,:);
[c1 ia1 ib1] = intersect(subg, allr.rlabels);
rnormclim = allr.rclimdata(ib1,climind);
rorigclim = allr.rorigclimdata(ib1,climind);
rfamcodes = allr.rfamcodes(ib1);
rrprop = rrprop(ia1);
rrcounts = rrcounts(ia1,:);
rlabels = allr.rlabels;

% save files to be used for R mixed effects analyses
if cleanflag
  save('rtwitterme_clean', 'rnormclim', 'rorigclim', 'rrprop', 'rrcounts', 'rfamcodes', 'rlabels')
else
  save('rtwitterme_all', 'rnormclim', 'rorigclim', 'rrprop', 'rrcounts', 'rfamcodes', 'rlabels')
end
