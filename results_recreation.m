close all
clear all

load('2017-05-12_batchdata_updated_struct_errorcorrect')

batch1 = batch; 
numBat1 = size(batch1,2);

load('2017-06-30_batchdata_updated_struct_errorcorrect')

%Some batteries continued from the first run into the second. We append 
%those to the first batch before continuing.
add_len = [661, 980, 1059, 207, 481];
summary_var_list = {'cycle','QDischarge','QCharge','IR','Tmax','Tavg',...
    'Tmin','chargetime'};
batch2_idx = [8:10,16:17];
for i=1:5
    batch1(i).cycles(end+1:end+add_len(i)+1) = batch(batch2_idx(i)).cycles;
    batch1(i).summary.cycle(end+1:end+add_len(i)+1) = ...
        batch(batch2_idx(i)).summary.cycle;
    batch1(i).summary.QDischarge(end+1:end+add_len(i)+1) = ...
        batch(batch2_idx(i)).summary.QDischarge;
    batch1(i).summary.QCharge(end+1:end+add_len(i)+1) = ...
        batch(batch2_idx(i)).summary.QCharge;
    batch1(i).summary.IR(end+1:end+add_len(i)+1) = ...
        batch(batch2_idx(i)).summary.IR;
    batch1(i).summary.Tmax(end+1:end+add_len(i)+1) = ...
        batch(batch2_idx(i)).summary.Tmax;
    batch1(i).summary.Tavg(end+1:end+add_len(i)+1) = ...
        batch(batch2_idx(i)).summary.Tavg;
    batch1(i).summary.Tmin(end+1:end+add_len(i)+1) = ...
        batch(batch2_idx(i)).summary.Tmin;
    batch1(i).summary.chargetime(end+1:end+add_len(i)+1) = ...
        batch(batch2_idx(i)).summary.chargetime;
end

batch([8:10,16:17]) = [];
batch2 = batch;
numBat2 = size(batch2,2);
clearvars batch

load('2018-04-12_batchdata_updated_struct_errorcorrect')
batch3 = batch;
batch3(38) = []; %remove channel 46 upfront; there was a problem with 
%the data collection for this channel
numBat3 = size(batch3,2);
endcap3 = zeros(numBat3,1);
clearvars batch
for i = 1:numBat3
    endcap3(i) = batch3(i).summary.QDischarge(end);
end
rind = find(endcap3 > 0.885);
batch3(rind) = [];

%remove the noisy Batch 8 batteries
nind = [3, 40:41];
batch3(nind) = [];
numBat3 = size(batch3,2);

batch_combined = [batch1, batch2, batch3];
numBat = numBat1 + numBat2 + numBat3;

%optionally remove the batteries that do not finish in Batch 1; depending
%on the modeling goal, you may not want to do this step
batch_combined([9,11,13,14,23]) = [];
numBat = numBat - 5;
numBat1 = numBat1 - 5; 

clearvars -except batch_combined numBat1 numBat2 numBat3 numBat
%correcting the error with the data
updated_cycle_life = [1852,2160,2237,1434,1709];
for i=1:5
    batch_combined(i).cycle_life = updated_cycle_life(i);
end
%%
variance = [];
cycle_life = [];
highest = 0;
lowest = 1000;

for i=1:124
    change = batch_combined(i).cycles(100).Qdlin - batch_combined(i).cycles(10).Qdlin;
    if var(change) > highest
        highest = var(change);
        highindex = i;
    elseif var(change) < lowest
        lowest = var(change);
        lowindex = i;
    end
    variance = [variance var(change)];
    cycle_life = [cycle_life batch_combined(i).cycle_life];
end
%creates the csv file
variance_data = [variance;cycle_life]';
csvwrite('variance_data.csv',variance_data)