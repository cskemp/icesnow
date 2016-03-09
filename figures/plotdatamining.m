load('../colexificationdata/idspluscolex');
load('../mixedeffectsanalyses/datamining_idsplus_me.mat');

rd = load('../mixedeffectsanalyses/ridsplusdata');

% index of the temperature variable
dim = 6;

gray = 0.4*ones(1,3);
black = [0,0,0];

% use p-values to rank pairs 
mpreds = -1*(pval(:,dim));
mpreds(conv(:, dim)==2) = nan;

pairinds = 1:length(mpreds);
inclind= ~isnan(mpreds);
mpreds = mpreds(inclind);
mcoeff = preds(inclind,dim);
pairinds = pairinds(inclind);

% include in table only pairs with positive coefficients
mpreds(mcoeff < 0) = -1;
[mpreds, sind] = sort(mpreds, 'descend');
pairinds = pairinds(sind);

cs = textread('../colexificationdata/ids_keys','%s', 'delimiter', '\n');
for i = 1:length(cs)
  c = cs{i};
  [tok, rem] = strtok(c, char(9));
  cs{i} = rem(2:end);
end

%  print table including 20 pairs with the smallest p values
for i = 1:20
  f(i) = pairinds(i);
  row = abs(preds(f(i),:));
  [m,mind] = nanmax(row);
  mind = dim;
  s1(i) = lpairs(f(i),1);
  s2(i) = lpairs(f(i),2);
  tocount = rd.reditd(:,f(i));
  incl = (~isnan(tocount) & ~isnan(rd.rclimdata(:,mind)));
  tocount = full(tocount(incl));
  disp(sprintf('%3d.[%5d]  %28s - %28s: %25s (%5.2f, %5.4f, %3d) %3d', i, f(i), cs{s1(i)}, cs{s2(i)}, rd.rvname{mind}, preds(f(i), mind), log(pval(f(i), mind)),  conv(f(i), mind), sum(tocount==1)));
end

figure(1)
clf;

inclind = find(inclind);
inclindneg =  find(preds(inclind,dim)<0);
inclindpos =  find(preds(inclind,dim)>=0);

subplot('position', [0.1, 0.1, 0.84, 0.3]);

% counts for pairs with positive coefficient
countspos = histc(-log(pval(inclind(inclindpos),dim)), 0:0.5:12);

% counts for pairs with negative coefficient
counts = histc(log(pval(inclind(inclindneg),dim)), -9:0.5:0);
% allow for cases with negative coefficient and p-value of 1
counts(end-1) = counts(end-1) + counts(end);

% combine counts for pairs with negative, positive coefficients
allcs = [counts(1:end-1); countspos(1:end-1)];
lpiece = 0*allcs; rpiece = lpiece;

lpiece(1:18) = allcs(1:18);
rpiece(19:end) = allcs(19:end);

b1 = bar(lpiece);
set(b1, 'edgecolor', gray, 'facecolor', gray);
hold on
b2 = bar(rpiece);
set(b2, 'edgecolor', black, 'facecolor', black);

v = axis; v(2) = 42.5; v(4) = 140; axis(v);

set(gca, 'xtick', [2.5, 6.5, 10.5, 14.5, 18.5,  22.5, 26.5, 30.5, 34.5, 38.5, 42.5]);
set(gca, 'xticklabel', { '8', '6', '4', '2', '0', '2', '4', '6', '8', '10', '12', });

h = line([40,40], [25, 7], 'color', 0.7*ones(1,3));
text(40, [35], 'ice/snow', 'horizontalalign', 'center');

box off

text(6.5, -28, '-ln(p value)', 'horizontalalign', 'center');
text(30.5, -28, '-ln(p value)', 'horizontalalign', 'center');

set(gca, 'tickdir', 'out');

colormap gray
ylabel('pair count ');

print(gcf, '-depsc', 'idsplusdatamining');

figure(2)


% in both cases "male" is an adjective used of an animal

labinds = [15043, 168, 10076, 7498, 1795, 17476, 9989, 5546]
labs = {'ice/snow', 'air/wind', 'man/male', 'hair/pubic hair', 'brick/adobe', 'vine/rope', 'male/bull', 'father/father''s brother'}


subplot('position', [0.2, 0.2, 0.5, 0.5]);

awx = -log(pval(labinds(2), dim));
awy = preds(labinds(2), dim);

h = line([0, 12], [0, 0], 'color', 0.6*ones(1,3));
hold on
h = line([awx,awx], [awy-0.005, awy-0.022], 'color', 0.6*ones(1,3));

scatter(-log(pval(inclind,dim)), preds(inclind,dim), 8, 0.4*[1 1 1], 'o', 'filled');
icesnowind = 15043;
scatter(-log(pval(icesnowind,dim)), preds(icesnowind,dim), 10, 'ko', 'filled');
axis square;
v = axis; v(2) = 12; axis(v);
ylabel('regression coefficient');
xlabel('-ln(p value)');

tweak = zeros(length(labinds), 2);
tweak(:, 1) = 0.2;
tweak(1,2) = -0.011; % ice/snow
tweak(2,:) = [-1.3, -0.04]; % air/wind
tweak(4,2) = 0.009;  % hair/pubic hair
tweak(5,2) = 0.007;  % brick/adobe
tweak(6,2) = 0.005;  % vine/rope
for i = 1:length(labinds)
  ind = labinds(i);
  if i == 1
    fw = 'bold';
  else
    fw = 'normal';
  end

  text(-log(pval(ind, dim))+tweak(i,1), preds(ind, dim)+tweak(i,2), labs{i}, 'fontsize', 9, 'fontweight', fw)
end

print(gcf, '-depsc', 'idsplusdatamining_scatter')


% plot lower end of 95% confidence interval on regression weight

figure(3)
lcs = lcfi(inclind,dim);
nonaninclind = inclind(~isnan(lcs));
lcs = lcs(~isnan(lcs));
[s,sind] = sort(lcs, 'descend');
nonaninclind = nonaninclind(sind);
hist(lcs, 30)
xlabel('lower end of 95% confidence interval')
print(gcf, '-depsc', 'idsplusdatamining_leftci')

% look at pairs such that lower end of 95% confidence interval is as high
% as possible

for i = 1:100
  nni = nonaninclind(i);
  s1(i) = lpairs(nni,1);
  s2(i) = lpairs(nni,2);
  tocount = rd.reditd(:,nni);
  incl = (~isnan(tocount) & ~isnan(rd.rclimdata(:,dim)));
  tocount = full(tocount(incl)); 
  disp(sprintf('%3d.[%5d]  %28s - %28s: (%5.2f -- %5.2f, %5.2f, %5.4f) %d', i, nni, cs{s1(i)}, cs{s2(i)}, lcfi(nni, dim), rcfi(nni, dim), preds(nni, dim), log(pval(nni,dim)), sum(tocount==1)));
end


