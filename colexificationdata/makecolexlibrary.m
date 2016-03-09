% did replace on commas

filename = 'librarydata.csv';
outfiles = {'dictiscolex'};

fid = fopen(filename,'r');
C = textscan(fid, repmat('%s',1,8), 'delimiter',',', 'CollectOutput',true);
C = C{1,1};
headers = C(1,:);
C = C(2:end,:);
nlang = size(C,1);

gcodeinds= [5];
colexinds = [4];

for ii = 1:length(gcodeinds)
  glottocodes = C(:,gcodeinds(ii));
  data = C(:, colexinds(ii));
  editd = nan*ones(length(glottocodes), 1);
  for i = 1:length(editd)
    if strcmp(data{i}, 'same')
      editd(i) = 1;
    elseif strcmp(data{i}, 'different')
      editd(i) = 0;
    else
      glottocodes{i}='';
    end
    if strcmp(glottocodes{i}, 'n/a')
      glottocodes{i} = '';
    end
  end
  save(outfiles{ii}, 'editd', 'glottocodes');
end

