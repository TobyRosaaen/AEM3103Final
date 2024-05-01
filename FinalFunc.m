%	Example 1.3-1 Paper Airplane Flight Path
%	Copyright 2005 by Robert Stengel
%	August 23, 2005


close all;
	global CL CD S m g rho	
	S		=	0.017;			% Reference Area, m^2
	AR		=	0.86;			% Wing Aspect Ratio
	e		=	0.9;			% Oswald Efficiency Factor;
	m		=	0.003;			% Mass, kg
	g		=	9.8;			% Gravitational acceleration, m/s^2
	rho		=	1.225;			% Air density at Sea Level, kg/m^3	
	CLa		=	3.141592 * AR/(1 + sqrt(1 + (AR / 2)^2));
			
    % Lift-Coefficient Slope, per rad
	CDo		=	0.02;			% Zero-Lift Drag Coefficient
	epsilon	=	1 / (3.141592 * e * AR);% Induced Drag Factor	
	CL		=	sqrt(CDo / epsilon);	% CL for Maximum Lift/Drag Ratio
	CD		=	CDo + epsilon * CL^2;	% Corresponding CD
	LDmax	=	CL / CD;			% Maximum Lift/Drag Ratio
	Gam		=	-atan(1 / LDmax);	% Corresponding Flight Path Angle, rad
	V		=	sqrt(2 * m * g /(rho * S * (CL * cos(Gam) - CD * sin(Gam))));
							% Corresponding Velocity, m/s
	Alpha	=	CL / CLa;			% Corresponding Angle of Attack, rad

    %Problem 1
    H		=	2;			% Initial Height, m
	R		=	0;			% Initial Range, m
	to		=	0;			% Initial Time, sec
	tf		=	6;			% Final Time, sec
    vNominal = 3.55; %m/s
    vHigh = 7.5; %m/s
    vLow = 2 ; %m/s
    GamNominal = -.18; %rad
    GamLow = - 0.5; %radians
    GamHigh =  0.4; %RADIANS 
	tspan	=	[to tf]; %Time span obviously

    %change v stuff
	xoNomV	=	[vNominal;GamNominal;H;R];
    xoLowV	=	[vLow;GamNominal;H;R];
    xoHighV	=	[vHigh;GamNominal;H;R];
    %Calculating numbers for V
    [tNomV,xNomV]	=	ode23('EqMotion',tspan,xoNomV);
    [tLowV,xLowV]	=	ode23('EqMotion',tspan,xoLowV);
    [tHighV,xHighV]	=	ode23('EqMotion',tspan,xoHighV);

    %changing gamma
    xoNomGam = [vNominal;GamNominal;H;R]; 
    xoLowGam = [vNominal;GamLow;H;R];
    xoHighGam = [vNominal;GamHigh;H;R];

    %calculating Numbers for varying gam
	[tNomG,xNomG]	=	ode23('EqMotion',tspan,xoNomGam);
    [tLowG,xLowG]	=	ode23('EqMotion',tspan,xoLowGam);
    [tHighG,xHighG]	=	ode23('EqMotion',tspan,xoHighGam);

    %plotting varying velocities
    subplot(2,1,1);
    plot(xNomV(:,4),xNomV(:,3),'-k',xLowV(:,4),xLowV(:,3),'-g',xHighV(:,4),xHighV(:,3),'-r'); 
    title('Height Vs. Range while Varying Velocity'); %this needs to be changed but idk what too
    legend('Nominal Velocity','Low velocity','High Velocity'); 
    xlabel('Range (m)');
    ylabel('Height (m)'); 
    grid on; 
    
    %second plot stuff
    subplot(2,1,2); 
    plot(xNomG(:,4),xNomG(:,3),'-k',xLowG(:,4),xLowG(:,3),'-g',xHighG(:,4),xHighG(:,3),'-r'); 
    title('Height Vs. Range While Varying Flight Path Angle')
    legend('Nominal Flight Path Angle','Low Flight Path Angle','High Flight Path Angle'); 
    xlabel('Range (m)');
    ylabel('Height (m)');
    grid on; 
    

    %QUESTION 2 and 3: 
    allTimes = []; 
    allRanges = []; 
    allHeights = [];  

    GammaMin = -0.5; 
    GammaMax = 0.4; 
    vMin = 2; 
    vMax = 7.5; 
    figure; 
    hold on; 
    for i = 1:100
        vRand = vMin + (vMax - vMin) * rand(1); 
        GammaRand = GammaMin + (GammaMax - GammaMin) * rand(1); 
        
        x0 = [vRand;GammaRand;H;R]; 
        [t,x] = ode23('EqMotion',tspan,x0); 

        allTimes = [allTimes; t];
        allRanges = [allRanges; x(:,4)]; 
        allHeights = [allHeights; x(:,3)];
        plot(x(:,4),x(:,3),'LineStyle','-'); 
    end
     
    xlabel("Range (m)"); 
    ylabel("Height (m)"); 
    grid on; 
    title("flight path with random velocity and flight path angle"); 
   
    allTimesCol = reshape(allTimes, [], 1);
    allRangesCol = reshape(allRanges,[],1); 
    allHeightsCol = reshape(allHeights,[],1); 
    fitTimes = linspace(min(allTimesCol), max(allTimesCol), 500); 
     
    pHeight = polyfit(allTimesCol,allHeightsCol,4); 
    heightFit = polyval(pHeight,fitTimes); 
    
    pRange = polyfit(allTimesCol,allRangesCol,4); 
    rangeFit = polyval(pRange,fitTimes); 

    plot(rangeFit, heightFit, '-g', 'LineWidth', 2);
   

    figure;
    plot(fitTimes, heightFit, '-g', 'LineWidth', 2); 
    xlabel('Time (s)'); 
    ylabel('Height (m)'); 
    title('Average Height Trajectory vs. Time'); 
    grid on;

    figure;
    plot(fitTimes, rangeFit, '-b', 'LineWidth', 2); 
    xlabel('Time (s)'); 
    ylabel('Range (m)'); 
    title('Average Range Trajectory vs. Time'); 
    grid on; 
    
    %last question
    Dheight_dt = diff(heightFit) ./ diff(fitTimes); 
    Drange_dt = diff(rangeFit) ./ diff(fitTimes); 

    timeForDerivatives = fitTimes(1:end-1);
    

    % Create the plots
    figure;

    % plotting derivitives stuff
    subplot(2,1,1);
    plot(timeForDerivatives, Dheight_dt, '-b');
    xlabel('Time (s)');
    ylabel('d(Height)/d(Time) (m/s)');
    title('Time Derivative of Height');
    grid on;

    % plotting more derivitive stuff
    subplot(2,1,2);
    plot(timeForDerivatives, Drange_dt, '-r');
    xlabel('Time (s)');
    ylabel('d(Range)/d(Time) (m/s)');
    title('Time Derivative of Range');
    grid on;

    tspan_A = to:0.05:tf;
    Animate2_int = [vHigh, GamHigh, H, R];

    [t_A,x_A] =	ode23('EqMotion',tspan_A,xoNomGam);
    [t2_A, x2_A] = ode23('EqMotion',tspan_A,Animate2_int);

    XNomialV = x_A(:,4);
    XnomialG = x_A(:,3);
    XMaxV = x2_A(:,4);
    XMaxG = x2_A(:,3);
    

   
    %plotting stuff

    marker = imread('Airplane1.png');

    f = figure('Position', [0 0 560 420]);
    xlim([0, max([XNomialV; XMaxV])]);
    ylim([-2, max([XnomialG; XMaxG])]);
    xlabel('Range (m)');
    ylabel('Height (m)');
    title('Animated Flight Paths');
    grid on;
    

    
    hold on;
    h1 = animatedline('Color','b','Marker','.','LineStyle','none'); % For nominal vel
    h2 = animatedline('Color','r','Marker','.','LineStyle','none'); % For high vel
    map = []; 
   
    for k = 1:length(t_A)
    
        addpoints(h1, XNomialV(k), XnomialG(k));
        addpoints(h2, XMaxV(k), XMaxG(k));

        if exist('imgHandle1', 'var')
            delete(imgHandle1);
        end
        if exist('imgHandle2', 'var')
            delete(imgHandle2);
        end

        imgHandle1 = image([XNomialV(k)-0.5, XNomialV(k)+0.5], [XnomialG(k)+0.5, XnomialG(k)-0.5], marker);
        imgHandle2 = image([XMaxV(k)-0.5, XMaxV(k)+0.5], [XMaxG(k)+0.5, XMaxG(k)-0.5], marker);
 
        drawnow;
        pause(.01);
        f = getframe(gcf);  
        if k == 1
             width2 = size(f.cdata,2); 
             height2 = size(f.cdata,1); 
             mov = zeros(height2,width2,1,length(t_A),'uint8');
            [mov(:,:,1,1), map] = rgb2ind(f.cdata,256,'nodither'); 
        else 
            mov(:,:,1,k) = rgb2ind(f.cdata,map,'nodither'); 

        end
    end
    hold off;

   % imwrite(mov,map,'animate.gif','DelayTime',0,'LoopCount',inf); 



