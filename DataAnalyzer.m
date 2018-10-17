
classdef DataAnalyzer < handle
    
    
    
    properties (Access = private)
        file
        path
        rawData
        cal
    end
    
    
    
    
    methods (Access = public)
        function obj = DataAnalyzer(manualVarNames)
            if exist('manualVarNames','var')
                obj.importData(1);
            else
                obj.importData();
            end
        end
        % Utility Functions
        function importData(obj, manualVarNames)
            % Select one or more files to read in
            [obj.file, obj.path] = uigetfile('*','MultiSelect','on');
            if isempty(obj.file)
                return
            end
            nFiles = length(obj.file);
            
            % Select the delimiter for this file
            delimNames  = [{'Bar (|)'},{'Comma (,)'},{'Semicollon (;)'},{'Space ( )'},{'Tab (\t)'}];
            delims       = [ '|', ',',';',' ',"\t"];
            [select, ok] = listdlg('ListString', delimNames,'SelectionMode','single',...
                                   'InitialValue',5,...
                                   'PromptString','Please select the correct delimiter');                 
            if ~ok
                return
            end
            dlm = delims(select);
            
            % Get Rows and columns to read
            prompt = {'Enter the row number for the FIRST row of Data'};
            title = 'Data Start';
            definput = {'4'};
            dataStart = inputdlg(prompt,title,[1 40],definput);
            row = str2double(dataStart{1});
            col = 0;
            
            obj.rawData = cell(nFiles,1);
            
            for i=1:nFiles
                obj.rawData{i} = dlmread(obj.path+string(obj.file(i)),dlm,row,col);
            end
            
            if exist('manualVarNames','var')
                obj.createWorkspaceVars();
            end
        end
        function  [x, y] = trimData(~,x, y, marker)
            if ~exist('marker','var'), marker = '-';end
            
            if iscell(x)
                for i=1:length(x)
                    handle = figure;
                    plot(x{i},y{i},marker);
                    [xlim,~] = ginput(1);
                    close(handle);
                    
                    where = find(x{i} > xlim);
                    temp1 = x{i};
                    temp2 = y{i};
                    x{i} = temp1(where);
                    y{i} = temp2(where);
                end
            else
                handle = figure;
                plot(x,y,marker);
                [xlim,~] = ginput(1);
                close(handle); 
                
                where = find(xvar > xlim);
                x = x(where);
                y = y(where);
            end    
        end
        function [cFit, xAvg, xStd] = calFit(obj, x, y,xLabel, yLabel)
           if ~exist('xLabel','var'), xLabel = 'x'; end
           if ~exist('yLabel','var'), yLabel = 'y'; end
            
           % For now we are assuming that the x data will always be a cell array
           [~,nCol] = size(x);
           xAvg = zeros(nCol,1);
           xStd = zeros(nCol,1);
           for i=1:nCol
              xAvg(i) = mean(x{i});
              xStd(i) = std(x{i});
           end
           
           hold on
           plot(xAvg,y,'ro','MarkerFaceColor','r');
           
           % add code for selecting fit type
           cFit = fit(xAvg,y,'poly1');
           plot(cFit,'b-');
           xlabel(xLabel);
           ylabel(yLabel);
           legend('Raw Data',[num2str(cFit.p1) 'x + ' num2str(cFit.p2)],'Location','best')
           obj.cal = cFit;
           hold off
        end
        function [y, xAvg, xStd] = applyCal(obj, x)
           % For now we are assuming that the x data will always be a cell array
           [~,nCol] = size(x);
           xAvg = zeros(nCol,1);
           xStd = zeros(nCol,1);
           y = zeros(nCol,1);
           for i=1:nCol
              xAvg(i) = mean(x{i});
              xStd(i) = std(x{i});
              y(i) = obj.cal(xAvg(i));
           end
        end
        
        % GET member access functions
        function files = getFile(obj)
           files = obj.file; 
        end
        function path = getPath(obj)
           path = obj.path; 
        end
        function rawData = getRawData(obj)
           rawData = obj.rawData; 
        end
    end
    
    
    
    
    methods (Access = private)
        function createWorkspaceVars(obj)
            [~, col] = size(obj.rawData{1});
            prompt = cell(1,col);
            for i=1:col
                prompt{i} = 'Enter Variable Name for Column'+string(i);
            end
            title = 'Variable Names';
            dims = [1 40];
            varNames = inputdlg(prompt,title,dims);
            varNames = genvarname(varNames);
            
            nTables = length(obj.rawData);
            
            for i=1:col
                temp = cell(1,nTables);
                for j=1:nTables
                    Table = obj.rawData{j};
                    temp{j} = Table(:,i);
                end
                assignin('base',varNames{i},temp)             
            end
        end
        
    end
end