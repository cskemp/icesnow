treefiles = {'../langtrees/idsplusentree.mat', '../langtrees/dictistree.mat', '../langtrees/twittertree.mat'}; 
colexfiles = {'../colexificationdata/idspluscolex.mat', '../colexificationdata/dictiscolex.mat', '../colexificationdata/twittercolex'};

routfiles = {'ridsplusdata',  'rdictisdata', 'rtwitterdata'};

codeconvert = tdfread('../autotypareas/code_mappings_iso_wals_autotyp_glottolog.csv');

fid = fopen('../autotypareas/lidareas.txt', 'r');
C = textscan(fid, '%d%d%s', 'delimiter', ',');
atlab = C{1}; atcode = C{2}; atname = C{3};
fclose(fid);

for k = 1:3
  load(treefiles{k});
  ed = load(colexfiles{k});
  if ~isfield(ed, 'langmat')
    ed.langmat= ones(size(ed.editd,1), 1);
  end
  rvname = vname;

  reditd = sparse(length(rlabels), size(ed.editd,2));
  rlangmat= sparse(length(rlabels), size(ed.langmat,2));
  rclimdata = zeros(length(rlabels), size(climdata,2));
  rclimdataind = zeros(length(rlabels), 1);

  for i = 1:length(rlabels)
    % index of this rlabel in tree file (which also includes climate data)
    cdinclind = find(ismember(gnames, rlabels{i}));
    assert(length(cdinclind)==1);
    rclimdataind(i) = climdataind(cdinclind);
    icode = icodes{cdinclind};
    ricodes{i} = icode;
    if isfield(ed, 'isocodes')  % for clicsids
      % index of this rlabel in colex file
      edinclind = find(ismember(ed.isocodes, icode));
    else			% for dictionary
      edinclind = find(ismember(ed.glottocodes, rlabels{i}));
    end

    % deal with NaNs properly
    if length(edinclind) == 1
      reditd(i,:) = ed.editd(edinclind,:);
      rlangmat(i,:) = ed.langmat(edinclind,:);
    else  % multiple languages in colex data map to this language code
      reditd(i,:) = double(any(ed.editd(edinclind,:), 1));
      rlangmat(i,:) = double(any(ed.langmat(edinclind,:), 1));
      allnan = all(isnan(ed.editd(edinclind,:)),1);
      reditd(i, allnan) = nan;
    end
    rclimdata(i,:) = nanmean(climdata(cdinclind,:),1);
  end

  rorigclimdata = rclimdata;

  % standardize climate variables
  for i = 1:size(rclimdata,2)
    cd = rclimdata(:,i);
    cd = cd - nanmean(cd);
    cd = cd./nanstd(cd);
    rclimdata(:,i) = cd;
  end

  % add autotyp areas
  rautotypcodes = 0*rfamcodes;
  rautotypnames= cell(size(rautotypcodes));

  for i = 1:length(rlabels)
    aind = find(ismember(codeconvert.Glottolog, rlabels{i}, 'rows'));
    % atypcode might be a vector
    atypcode = codeconvert.AUTOTYP(aind);
    atypcode = atypcode(~isnan(atypcode));
    if isempty(atypcode) % rlabels{i} isn't in codeconvert
      rautotypcodes(i) = nan;
      continue
    end
    anameind = [];
    for j = 1:length(atypcode) 
      janameind = find(atlab == atypcode(j));
      if ~isempty(janameind)
        anameind(j) = janameind;
      else % atypcode(j) is missing from lidareas.txt
        anameind(j) = nan;
      end
    end
    anameind = anameind(~isnan(anameind));
    if isempty(atypcode)
      rautotypcodes(i) = nan;
      continue
    end
    [ucode, ui, uj] = unique(atcode(anameind));
    tmp = atname(anameind);
    uatname = tmp(ui);
    counts = histc(atcode(anameind), ucode);
    % choose the autotyp area most common among languages that map onto
    % rlabels{i} 
    m = max(counts);
    allminds = find(counts==m);
    % ties arise for mode1248, stan1288 and toho1245. Break them in a way
    % that is correct (I think)
    if strcmp(rlabels{i}, 'toho1245') 
      mind = allminds(1);
    else
      mind = allminds(end);
    end
    rautotypcodes(i) = ucode(mind);
    rautotypnames(i) = uatname(mind);
  end

  save(routfiles{k}, 'reditd', 'rclimdata', 'rclimdataind', 'rlabels', 'rfamcodes', 'rautotypcodes', 'rautotypnames', 'rvname', 'rorigclimdata', 'rlangmat');
end
