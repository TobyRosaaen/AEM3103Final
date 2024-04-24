%	Example 1.3-1 Paper Airplane Flight Path
%	Copyright 2005 by Robert Stengel
%	August 23, 2005

clear all;
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
    
    %WHAT IS THE POINT OF GRAPHING BELOW 0 METERS ask prof
    

    %Animation
    
    tspan_A = to:0.1:tf;
    Animate2_int = [vHigh, GamHigh, H, R];
    marker = imread('Test.png');

    [t_A,x_A] =	ode23('EqMotion',tspan_A,xoNomGam);
    [t2_A, x2_A] = ode23('EqMotion',tspan_A,Animate2_int);

    XNomialV = x_A(:,4);
    XnomialG = x_A(:,3);
    XMaxV = x2_A(:,4);
    XMaxG = x2_A(:,3);
    
    figure
    hold on
    h = animatedline;
    h.ColorMode = "manual";
    h2 = animatedline;
    h2.ColorMode = "auto";
    for i=1:length(XNomialV)
        plot(XNomialV(i),XnomialG(i),'b')
        plot(XMaxV(i),XMaxG(i),'k')
        axis([0 25, -2 4]);
        xlabel('Range (m)');
        ylabel('Height (m)'); 
        grid on; 
        addpoints(h,XNomialV(i),XnomialG(i))
        addpoints(h2,XMaxV(i),XMaxG(i))
        drawnow;
        
        %if i~=length(XNomialV)
            %clf
        %end
    end
    hold off
    


    %QUESTION 2 and 3: 
    time = linspace(tspan(1),tspan(2),1000); 
    allRanges = zeros(1000,100); 
    allHeights = zeros(1000,100); 

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
        interpRange = interp1(t,x(:,4),time); 
        interpHeight = interp1(t,x(:,3),time); 
        allRanges(:,i) = interpRange; 
        allHeights(:,i) = interpHeight; 
        plot(x(:,4),x(:,3),'LineStyle','-'); 
    end
    xlabel("Range (m)"); 
    ylabel("Height (m)"); 
    grid on; 
    title("flight path with random velocity and flight path angle");     
    %QUESTION 2 NEEDS TO BE LOOKED AT AND SEE WHAT TO DO ABOUT THE GRAPH
    %IF IT LOOKS GOOD
    % I like the way it looks - CT
    averageRange = mean(allRanges,2); 
    averageHeights = mean(allHeights,2); 
    p = polyfit(time,averageHeights,3); %Mabye not 3rd degree mabye change
    heightFit = polyval(p,time); 
    
    p = polyfit(time,averageRange,3); 
    rangeFit = polyval(p,time); 

    figure;
    plot(rangeFit, heightFit, '-g', 'LineWidth', 2); 
    xlabel('Time (s)'); 
    ylabel('Height (m)'); 
    title('Average Height Trajectory vs. Time'); 
    grid on;

    figure;
    plot(time, rangeFit, '-b', 'LineWidth', 2); 
    xlabel('Time (s)'); 
    ylabel('Range (m)'); 
    title('Average Range Trajectory vs. Time'); 
    grid on; 
    
    %last question
    Dheight_dt = diff(averageHeights) ./ diff(time); 
    Drange_dt = diff(averageRange) ./ diff(time); 

    timeForDerivatives = time(1:end-1);%time dilation for derivitives
    

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



    %{
%	a) Equilibrium Glide at Maximum Lift/Drag Ratio
	H		=	2;			% Initial Height, m
	R		=	0;			% Initial Range, m
	to		=	0;			% Initial Time, sec
	tf		=	6;			% Final Time, sec
	tspan	=	[to tf];
	xo		=	[V;Gam;H;R];
	[ta,xa]	=	ode23('EqMotion',tspan,xo);
	
%	b) Oscillating Glide due to Zero Initial Flight Path Angle
	xo		=	[V;0;H;R];
	[tb,xb]	=	ode23('EqMotion',tspan,xo);

%	c) Effect of Increased Initial Velocity
	xo		=	[1.5*V;0;H;R];
	[tc,xc]	=	ode23('EqMotion',tspan,xo);

%	d) Effect of Further Increase in Initial Velocity
	xo		=	[3*V;0;H;R];
	[td,xd]	=	ode23('EqMotion',tspan,xo);
	
	figure
	plot(xa(:,4),xa(:,3),xb(:,4),xb(:,3),xc(:,4),xc(:,3),xd(:,4),xd(:,3))
	xlabel('Range, m'), ylabel('Height, m'), grid

	figure
	subplot(2,2,1)
	plot(ta,xa(:,1),tb,xb(:,1),tc,xc(:,1),td,xd(:,1))
	xlabel('Time, s'), ylabel('Velocity, m/s'), grid
	subplot(2,2,2)
	plot(ta,xa(:,2),tb,xb(:,2),tc,xc(:,2),td,xd(:,2))
	xlabel('Time, s'), ylabel('Flight Path Angle, rad'), grid
	subplot(2,2,3)
	plot(ta,xa(:,3),tb,xb(:,3),tc,xc(:,3),td,xd(:,3))
	xlabel('Time, s'), ylabel('Altitude, m'), grid
	subplot(2,2,4)
	plot(ta,xa(:,4),tb,xb(:,4),tc,xc(:,4),td,xd(:,4))
	xlabel('Time, s'), ylabel('Range, m'), grid
    %}
