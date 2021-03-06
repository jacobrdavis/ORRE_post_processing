%% ------------------------------ Header ------------------------------- %%
% Filename:     ORRE_post_processing.m
% Description:  ORRE Post Processing Program input file (test)
% Authors:      D. Lukas and J. Davis
% Created on:   6-10-20
% Last updated: 8-9-20 by J. Davis
%% --------------------------- Settings -------------------------------- %%

close all % close any open figures

% Execute app:

run_app = 1;
show_examples = 0;

if run_app == 1
    pkg.ORRE_post_processing_app
end


%% ----------------------------- Examples ------------------------------ %%
if show_examples == 1
% Define inputs:
directory = "./testdata/";     % current directory
filename = "90_deg_reg_run1.txt";
%filename = "3Decay Test Spring 0Deg_U_WaveID_Freq=0.5Hz Amp=0m ang=0rad__20180412_111119_.txt";
datatype = 1;
     % 1 - user-defined (dataClass)
  
% Call the <read_data.m> function to create an instance of the appropriate
% data class:   
data = pkg.fun.read_data(directory,filename,datatype);

%%% Note:
% The function <read_data.m> is designed to take a variable number of input 
% arguments. The complete call options are as follows:
%
% data = pkg.fun.read_data(data_dir,filename,datatype,ntaglines,nheaderlines,tagformat,headerformat,dataformat,commentstyle)
% 
% Only the first three inputs (data_dir,filename, and datatype) are
% required. The remaining inputs are optional and pertain only to the
% user-defined data class (datatype 1)

%%% Example of calling a function

% test of call method 1: direct input of data arrays
dominant_period = pkg.fun.plt_fft(data.ch1,data.ch2);

% test of call method 2: channel indicators
dominant_period = pkg.fun.plt_fft(1,3,data);

% test of bad calls:
dominant_period = pkg.fun.plt_fft(10,2,data); % returns error for nonexistent channel
dominant_period = pkg.fun.plt_fft(1.1,2,data); % returns error for non-int channel indicator


%%% Plotting example with use of data.map feature:

% Hard-coded:
figure
plot(data.ch1,data.ch2)
xlabel(data.map('ch1'))
ylabel(data.map('ch2'))


% Given the desired channel numbers, this is can be dynamically coded 
% (I think I made that term up) as the following:

% user-defined channels to plot:
n = '1';
m = '2';

figure
plot(data.(strcat('ch',n)),data.(strcat('ch',m)))
xlabel(data.map(strcat('ch',n)))
ylabel(data.map(strcat('ch',m)))

end

%% ----------------------------- Scripting ----------------------------- %%
if run_app ~= 1
     
    writedata = 0;
    
    Ts = 0.020000;
    
    datatype = 1;
    
    myDir = 'C:\Users\jacob\Documents\ORRE_Offline\NREL TCF\OSWEC\W2 Testing\Regular Wave Response\0 Deg\';
    myFiles = dir(fullfile(myDir,'*.txt'));
   
    dataset = cell(length(myFiles),1);
    
    for k = 1:length(myFiles)
        baseFileName = myFiles(k).name;
        fullFileName = fullfile(myDir, baseFileName);  % Changed myFolder to myDir
        fprintf(1, 'Now reading %s\n', fullFileName);
        data = pkg.fun.read_data(myDir,baseFileName,datatype,0,1,'~','~','~',' ','~');
        dataset{k,1} = data;
        
    end
    
    
    myDir2 = 'C:\Users\jacob\Documents\ORRE_Offline\NREL TCF\OSWEC\W2 Testing\From Mike\WEC testing\Labview DATA\Waves 0Deg\Test\';
    myFiles2 = dir(fullfile(myDir2,'*.txt'));
   
    dataset2 = cell(length(myFiles2),1);
    
    for k = 1:length(myFiles2)
        baseFileName2 = myFiles2(k).name;
        fullFileName2 = fullfile(myDir2, baseFileName2);  % Changed myFolder to myDir
        fprintf(1, 'Now reading %s\n', fullFileName2);
        data2 = pkg.fun.read_data(myDir2,baseFileName2,datatype);
        data2.ch1 = sqrt(data2.ch1).*Ts;
        dataset2{k,1} = data2;
    end
    
    plot(dataset{14}.ch1,dataset{14}.ch2)
    
    plot(dataset2{14}.ch1,dataset2{14}.ch7); hold on
    plot(dataset2{14}.ch1,dataset2{14}.ch8);
    
    h = 0.631/2;
    asin((dataset2{14}.ch7 - mean(dataset2{14}.ch7))/h)*180/pi;
    
     plot(dataset2{14}.ch1,dataset2{14}.ch7 - dataset2{14}.ch8)
     
     response = asin(abs(dataset2{14}.ch7)/h);
     
     
end


% 
%   for k = 1:length(myFiles)
%         baseFileName = myFiles(k).name;
%         fullFileName = fullfile(myDir, baseFileName);  % Changed myFolder to myDir
%         fprintf(1, 'Now reading %s\n', fullFileName);
%         data = pkg.fun.read_data(myDir,baseFileName,datatype);
%         data.ch1 = sqrt(data.ch1).*Ts;
%         dataset{k,1} = data;
%         if writedata == 1
%             combined_data = [];
%             for ch = 1:length(data.headers)
%                 combined_data(:,ch) = data.(strcat('ch',num2str(ch)));
%             end
%             
%             data.tags = split(data.tags{1},char(9));
%             datestring = split(data.tags{2},'_');
%             Y = extractBetween(datestring{2},1,4);
%             M = extractBetween(datestring{2},5,6);
%             D = extractBetween(datestring{2},7,8);
%             
%             data.tags{2} = datestr(datetime(cellfun(@str2num,{Y{1} M{1} D{1}})));
%             
%             outputdir = 'C:\Users\jacob\Documents\ORRE_Offline\NREL TCF\OSWEC\W2 Testing\Fixed\';
%             headerfmt = [repmat('%s,',1,length(data.headers)-1),'%s'];
%             
%             fid = fopen(strcat(outputdir,data.filename),'wt'); 
%             fprintf(fid, '%s %s %s \n', data.tags{1}, data.tags{3}, data.tags{2});
%             fprintf(fid, headerfmt, data.headers{:});
%             fclose(fid);
%             
% %           dlmwrite(strcat(outputdir,data.filename),combined_data,'delimiter','\t','-append','precision','%10.8f')           
%             writematrix(combined_data,strcat(outputdir,data.filename),'WriteMode','append')      
%         end
%     end






