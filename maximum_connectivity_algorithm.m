
[file,dir] = uigetfile('*.xlsx');
if dir ==0
    error('Please select a file.');
end
file = fullfile(dir,file);
[mole_link,mole_name,link_intens] = extract_link(file);
list = {};
for mole_idx = 1:length(mole_name)
    [list,mole_link] = combine_list_with_certain(list,mole_idx,mole_link,link_intens,mole_name);
end
strength = list(:,3);
strength = cell2mat(strength);
[~,idx] = sort(strength);
list = list(flipud(idx),:);

T = cell2table(list,'VariableNames',{'Combination','Strength_Prod','Strength_Sum','Comb_Num'});
writetable(T,strrep(file,'.xlsx','_combination.xlsx'));
function [mole_link,mole_name,link_intens] = extract_link(file)

[dataset,mole_name] = xlsread(file);


thresh = mole_name{1,1};
mole_name = mole_name(1,2:end);

thresh = strsplit(thresh,'=');
thresh = thresh{2};
thresh = str2double(thresh);



mole_num = length(dataset);
sing = diag(dataset);
m1 = repmat(sing,1,mole_num);
m2 = m1';
mag1 = dataset./m1;
mag2 = dataset./m2;
link_intens = (mag1+mag2)/2;
connect = (mag1>thresh).*(mag2>thresh);
link_num = sum(connect(:));
[x,y] = find(connect==1);
mole_link = cell(1,mole_num);
link_output = cell(link_num,2);
link_ind = 1;
for mole = 1:mole_num
    links = y(x==mole);
    mole_link{mole}=links;
    links(links<mole)=[];
    current_name = mole_name(mole);
    for k = 1:length(links)
        current_link = mole_name(links(k));
        link_output{link_ind,1} = [current_name{1},'-', current_link{1}];
        link_strength = link_intens(mole,links(k));
        link_output{link_ind,2} = link_strength;
        link_ind = link_ind+1;
    end
end

connect_output = strrep(file,'.xls','_link.xls');
T = cell2table(link_output,'VariableNames',{'molecule_links','link_strength'});
writetable(T,connect_output);

out = cell(mole_num+1);
out(1,2:end) = mole_name;
out(2:end,1) = mole_name';
out(2:end,2:end) = num2cell(link_intens);
link_intens_output = strrep(file,'.xls','_strength.xls');
xlswrite(link_intens_output,out);
link_intens(~connect)=0;
end
function namelist = listnum2name(list,mole_name)
namelist = [];
for k = 1:length(list)
    namelist = [namelist,mole_name{list(k)},','];
end
namelist(end)=[];
end
function [list,mole_link] = combine_list_with_certain(list,mole_idx,mole_link,link_intens,mole_name)

waiting_mole = mole_link{mole_idx};
waiting_num = length(waiting_mole);

for comb_num = 2:waiting_num
    prob_list = nchoosek(waiting_mole,comb_num);
    for i = 1:size(prob_list,1)
        current_set = prob_list(i,:);
        [connect_strength,connect_strength_add] = whether22(current_set,link_intens);
        if connect_strength>0  
            s = size(list,1)+1;
            list{s,1} = listnum2name([mole_idx,current_set],mole_name);
            link_between_set = (comb_num+1)*comb_num/2;%linkµÄÊıÁ¿
            connect_strength = connect_strength * prod(link_intens(mole_idx,current_set));
            connect_strength = connect_strength^(1/link_between_set);
            connect_strength_add = connect_strength_add + sum(link_intens(mole_idx,current_set));
%             connect_strength_arith = connect_strength_add/link_between_set;
            list{s,2} = connect_strength;          
            list{s,3} = connect_strength_add;
            list{s,4} = comb_num+1;
        end
    end
end
for k= 1:waiting_num
    current_mole = waiting_mole(k);
    current_link = mole_link{current_mole};
    current_link(current_link==mole_idx)=[];
    mole_link{current_mole}=current_link;
end
end
function [connect_strength,connect_strength_add] = whether22(current_set,link_intens)
n = length(current_set);
connect_strength = 1;
connect_strength_add = 0;
for k = 1:n-1
    for j = k+1:n
        connect_strength = connect_strength*link_intens(current_set(k),current_set(j));
        connect_strength_add = connect_strength_add+link_intens(current_set(k),current_set(j));
    end
end
end
