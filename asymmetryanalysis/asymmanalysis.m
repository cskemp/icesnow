
for anind = 1:2
  if anind == 1
    clear all
    anind = 1
    load('../mixedeffectsanalyses/rdictisdata.mat')
    trait01 = full(reditd);
  else
    clear all
    anind = 2
    load('../mixedeffectsanalyses/ridsplusdata.mat')
    % find icesnow vector
    trait01 = reditd(:,15043); 
  end
  % mean monthly temperature
  climind = 6; 
  climdata = rorigclimdata(:, climind)/10;
  gray = 0.4*ones(1,3);

fams = unique(rfamcodes);

nperm = 10000;
ld = zeros(nperm,1);
rd = zeros(nperm,1);

rng(0)
for i = 1:nperm
  ms = zeros(1, length(fams));
  ss = zeros(1, length(fams));
  for fi = 1:length(fams)
    mergers =  find(rfamcodes == fams(fi) & trait01 == 1);
    mergers =  find(rfamcodes == fams(fi) & trait01 == 1);
    mergers = mergers(randperm(length(mergers)));
    if ~isempty(mergers)
      ms(fi) = mergers(1);
    end
    splitters =  find(rfamcodes == fams(fi) & trait01 == 0);
    splitters= splitters(randperm(length(splitters)));
    if ~isempty(splitters)
    ss(fi) = splitters(1);
    end
  end
  ms = climdata(ms(ms>0));
  ss = climdata(ss(ss>0));
  nm = length(ms); ns = length(ss);
  ms = ms(randperm(nm));
  ss = ss(randperm(ns));
  minn = min([nm,ns]);
  % make sure samples of mergers, splitters have same size
  ms = ms(1:minn);
  ss = ss(1:minn);
  mqs(i,:) = quantile(ms,3);
  sqs(i,:) = quantile(ss,3);
end

ld = mqs(:,1) - sqs(:,1);
rd = mqs(:,3) - sqs(:,3);

histplots = [ld, rd, ld-rd];

titles{1,1} = 'Q_1(lumpers) - Q_1(splitters)';
titles{1,2} = 'Q_3(lumpers) - Q_3(splitters)';
titles{1,3} = 'Q_1 diff - Q_3 diff';
titles{2,1} = '';
titles{2,2} = '';
titles{2,3} = '';

filenames{1,1} = 'Q1dict';
filenames{1,2} = 'Q3dict';
filenames{1,3} = 'Qdiffdict';
filenames{2,1} = 'Q1ids';
filenames{2,2} = 'Q3ids';
filenames{2,3} = 'Qdiffids';

for j = 1:3
  clf
  subplot('position', [0.3, 0.3, 0.2, 0.2])
  thiscol = histplots(:,j);
  counts = histc(thiscol, -25:2.5:25);
  % last bin contains values that match edges(end) -- we don't need this
  counts = counts(1:end-1);
  lpiece = 0*counts; rpiece = lpiece;
  n = div(length(counts),2);
  lpiece(1:n) = counts(1:n);
  rpiece(n+1:end) = counts(n+1:end);
  b1 = bar(lpiece);
  set(b1, 'edgecolor', gray, 'facecolor', gray);
  hold on
  b2 = bar(rpiece);
  set(b2, 'edgecolor', 'black', 'facecolor', 'black');
  v = axis; v(2) = length(counts)+0.5; v(4) = 4875; axis(v);
  disp(max(counts));

  set(gca, 'xtick', -0.5 + [3, 7, 11, 15, 19]);
  set(gca, 'xticklabel', {'-20', '-10', '0', '10', '20'});
  set(gca, 'tickdir', 'out', 'fontsize', 10);
  box off
  if (sum(thiscol<0)/length(thiscol)) == 0
    title('proportion below 0 = 0');
  else
  title(sprintf('proportion below 0 =  %.2f',  sum(thiscol<0)/length(thiscol)));
  end
  if (0 && anind == 2)
    text(10.5, -1100, sprintf('%sC', char(176)), 'horizontalalign', 'center', 'verticalalign', 'top'); 
  end
  print(1, '-depsc', filenames{anind, j});
end
end

