function EEGplot_seg(dataseg,  srate, range, ch_name)
% plot multichannel EEG - small version v.s. [f]:EEGplot
% dataseg - each row represent one Channel
% srate=100; range=300;

dataseg=1*dataseg;

%     if reverse==1
%         dataseg=-1*dataseg;
%     end

Lw=0.5;
if nargin==3
    Ch=size(dataseg,1); L=size(dataseg,2); 
    %% plot 'ST'
    for i=1:Ch
        Time = [0:L-1]*(1/srate);
        Y = (dataseg(i,:) - mean(dataseg(i,:)))./range + (1-i);
        PlotColor = 'k';
        plot(Time,Y,'LineWidth',Lw,'color',PlotColor);
    %         plot(Y,'LineWidth',0.01,'color',PlotColor);
        hold on    
    end

    % plot the scale lable - amplitude scale and one second
    % set the original of this lable
    Td=L/srate;
    original_x=Td-1;
    original_y=-Ch+1;
    LW=2;
    %  vertical bar
    plot([original_x, original_x], [original_y-1, original_y],'LineWidth',LW);
    %  horizontal bar
    plot([original_x, original_x+1], [original_y-1, original_y-1],'LineWidth',LW)
    hold off
    % Set the yTick
    YTick=[(-Ch+1):0];
    set(gca,'YTick',YTick);
    % Set the ylim
    ylim([-Ch 1]);
    Chname=fliplr([1:Ch]); 
    set(gca,'YTickLabel',Chname);
%     xlabel('Time (second)')
    
elseif nargin>=3  
    % return EEGseg
     Ch=size(dataseg,1); L=size(dataseg,2); 
    %% plot 'ST'
    for i=1:Ch
        Time = [0:L-1]*(1/srate);
        Y = (dataseg(i,:) - mean(dataseg(i,:)))./range + (1-i);
        PlotColor = 'k';
        plot(Time,Y,'LineWidth',Lw,'color',PlotColor);
    %         plot(Y,'LineWidth',0.01,'color',PlotColor);
        hold on    
    end

    % plot the scale lable - amplitude scale and one second
    % set the original of this lable
    Td=L/srate;
    original_x=Td-1;
    original_y=-Ch+1;
    LW=2;
    %  vertical bar
    plot([original_x, original_x], [original_y-1, original_y],'LineWidth',LW);
    %  horizontal bar
    plot([original_x, original_x+1], [original_y-1, original_y-1],'LineWidth',LW)
    hold off
    % Set the yTick
    YTick=[(-Ch+1):0];
    set(gca,'YTick',YTick);
    % Set the ylim
    ylim([-Ch 1]);
    Chname=fliplr(ch_name'); % Bottom to Top
    set(gca,'YTickLabel',Chname');
%     xlabel('Time (second)')
end

    
    