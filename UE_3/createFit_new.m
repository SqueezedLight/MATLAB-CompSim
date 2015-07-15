function cf_ = createFit_new(t_draw,rho_E)
%CREATEFIT    Create plot of datasets and fits
%   CREATEFIT(T_DRAW,RHO_E)
%   Creates a plot, similar to the plot in the main curve fitting
%   window, using the data that you provide as input.  You can
%   apply this function to the same data you used with cftool
%   or with different data.  You may want to edit the function to
%   customize the code and this help message.
%
%   Number of datasets:  1
%   Number of fits:  1


% Data from dataset "rho_E vs. t_draw":
%    X = t_draw:
%    Y = rho_E:
%    Unweighted
%
% This function was automatically generated on 03-Dec-2010 07:00:08

% Set up figure to receive datasets and fits
f_ = clf;
figure(f_);
set(f_,'Units','Pixels','Position',[490 176 672 475]);
legh_ = []; legt_ = {};   % handles and text for legend
xlim_ = [Inf -Inf];       % limits of x axis
ax_ = axes;
set(ax_,'Units','normalized','OuterPosition',[0 0 1 1]);
set(ax_,'Box','on');
axes(ax_); hold on;


% --- Plot data originally in dataset "rho_E vs. t_draw"
t_draw = t_draw(:);
rho_E = rho_E(:);
h_ = line(t_draw,rho_E,'Parent',ax_,'Color',[0.333333 0 0.666667],...
    'LineStyle','none', 'LineWidth',1,...
    'Marker','.', 'MarkerSize',12);
xlim_(1) = min(xlim_(1),min(t_draw));
xlim_(2) = max(xlim_(2),max(t_draw));
legh_(end+1) = h_;
legt_{end+1} = 'rho_E vs. t_draw';

% Nudge axis limits beyond data limits
if all(isfinite(xlim_))
    xlim_ = xlim_ + [-1 1] * 0.01 * diff(xlim_);
    set(ax_,'XLim',xlim_)
else
    set(ax_, 'XLim',[-10, 1010]);
end


% --- Create fit "fit 1"
ok_ = isfinite(t_draw) & isfinite(rho_E);
if ~all( ok_ )
    warning( 'GenerateMFile:IgnoringNansAndInfs', ...
        'Ignoring NaNs and Infs in data' );
end
st_ = [0.31112948263898754231 ];
ft_ = fittype('exp(-b*x)',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'b'});

% Fit this model using new data
cf_ = fit(t_draw(ok_),rho_E(ok_),ft_,'Startpoint',st_);

% Or use coefficients from the original fit:
if 0
    cv_ = { 0.49636340773701320694};
    cf_ = cfit(ft_,cv_{:});
end

% Plot this fit
h_ = plot(cf_,'fit',0.95);
legend off;  % turn off legend from plot method call
set(h_(1),'Color',[1 0 0],...
    'LineStyle','-', 'LineWidth',2,...
    'Marker','none', 'MarkerSize',6);
legh_(end+1) = h_(1);
legt_{end+1} = 'fit 1';

% Done plotting data and fits.  Now finish up loose ends.
% hold off;
% leginfo_ = {'Orientation', 'vertical', 'Location', 'NorthEast'};
% h_ = legend(ax_,legh_,legt_,leginfo_{:});  % create legend
% set(h_,'Interpreter','none');
% xlabel(ax_,'');               % remove x label
% ylabel(ax_,'');               % remove y label
