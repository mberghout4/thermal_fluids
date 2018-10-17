% Define known constants
nu    = 1.562 * 10^-5;         % Kinematic viscosity of air at 25C [m^2/s]
rho   = 1.184;                 % Density of air at 25C kg/m^3
A     = 2.0 *0.0132313;         % Area of the wing [m^2]
Lc    = 0.0551;                % Average Chord Length [m]
alpha = [0 2 3 4 5 6 7 8 10]'; % Angle of Attack in degrees

%path to data
path = '/Users/mattberghout/Desktop/Matt School/Matt USU/Fall_18/Fluids:Thermal Lab(MAE-4400)/Lab/Lab_4_Drone/Data';
folder = '/'+string(alpha)+' degrees/';
files = string(15:2:35)+'.xlsx';

for j=1:length(alpha)
    % Ingest raw data -> get average values and stdDev of each column [u (m/s); lift (N);
    % drag (N)] (should result in coupled vectors.)
    nFiles  = length(files);

    timeRaw = cell(nFiles,1);
    uRaw    = cell(nFiles,1);
    FlRaw   = cell(nFiles,1);
    FdRaw   = cell(nFiles,1);

    u  = zeros(nFiles,1);
    Fl = zeros(nFiles,1);
    Fd = zeros(nFiles,1);

    for i=1:nFiles
        fileName = path+folder(j)+string(files(i));
        [data, ~] = xlsread(fileName);
        timeRaw{i} = data(:,1);
        uRaw{i}    = data(:,2);
        FlRaw{i}   = data(:,3);
        FdRaw{i}   = data(:,4);

        u(i)  = mean(double(uRaw{i}));
        Fl(i) = mean(double(FlRaw{i}));
        Fd(i) = mean(double(FdRaw{i}));
        
    end

    % Calculate Re, Cl, Cd from average vectors
    Re = u.*Lc/nu;
    Cl = (2.*Fl)./(rho.*u.^2.*A);
    Cd = (2.*Fd)./(rho.*u.^2.*A);

    % Create Plots
    % [Cl, Cd, Cl/Cd] vs. Re
    h1 = figure;
    plot(Re,Cl);
    xlabel('Re')
    ylabel('C_L')
    fileName = path+folder(j)+'Cl_vs_Re.fig';
    savefig(fileName);
    close(h1);

    h2 = figure;
    plot(Re,Cd);
    xlabel('Re')
    ylabel('C_d')
    fileName = path+folder(j)+'Cd_vs_Re.fig';
    savefig(fileName);
    close(h2);

    h3 = figure;
    plot(Re,Cl./Cd);
    xlabel('Re')
    ylabel('C_L/C_d')
    fileName = path+folder(j)+'Cl_over_Cd_vs_Re.fig';
    savefig(fileName);
    close(h3);
    
    Cla(:,j) = Cl;
    Cda(:,j) = Cd;
    
    header = ['Speed [m/s],' 'Lift Force [N],' 'Drag Force [N],' 'Re,' 'Cl,' 'Cd'];
    processedData = [u Fl Fd Re Cl Cd];
    fileName = path+folder(j)+'processedData.csv';
    
    %write header to file
    fid = fopen(fileName,'w'); 
    fprintf(fid,'%s\n',header);
    fclose(fid);
    %write data to file
    dlmwrite(fileName,processedData,'-append','precision',12);
end

for i=1:nFiles
    % [Cl, Cd, Cl/Cd] vs. alpha
    h4 = figure;
    plot(alpha,Cla(i,:)');
    xlabel('\alpha')
    ylabel('C_L')
    fileName = strcat(path,'Cl_vs_alpha.fig');
    savefig(fileName);
    close(h4);

    h5 = figure;
    plot(alpha,Cda(i,:)');
    xlabel('\alpha')
    ylabel('C_d')
    fileName = strcat(path,'Cd_vs_alpha.fig');
    savefig(fileName);
    close(h5);

    h6 = figure;
    la = Cla(i,:);
    da = Cda(i,:);
    cldl = (Cla(i,:)./Cda(i,:));
    plot(alpha,(Cla(i,:)./Cda(i,:))');
    xlabel('\alpha')
    ylabel('C_L/C_d')
    fileName = strcat(path,'Cl_over_Cd_vs_alpha.fig');
    savefig(fileName);
    close(h6);
end

% Calculate results:
    % 
    % u_drone -> maximize Cl/Cd then ensure (u_drone - u_stall) > 5m/s
    % aphla (maximize Cl/Cd)
    % Fl = 1/2 * rho * u_drone^2 * A_wing * Cl
    % Fd = 1/2 * rho * u_drone^2 * A_wing * Cd
    % Thrust_prop
    % Power_prop
    % Batter specs
    % u_launch
    % launch method
    % total mass

