function SDtAListBoxValueChanged (app, event)
app.StatsTable.Data = [];
cla(app.TimeHistoryAxes);
hold(app.TimeHistoryAxes);

app.SelectDatatoAnalyzeListBox.Multiselect = 'on';
app.SelectDatatoAnalyzeListBox.ItemsData = 1:numel(app.SelectDatatoAnalyzeListBox.Items);
value = app.SelectDatatoAnalyzeListBox.Value;

app.TimeHistTimeDropDown.ItemsData = 1:numel(app.TimeHistTimeDropDown.Items);
timehisttimevalue = app.TimeHistTimeDropDown.Value;

rowname = {};
value = sort(value);

for lbvalue = value(1:end)
    y = app.Wavedata.(strcat('ch',(num2str(lbvalue))));
    hold(app.TimeHistoryAxes,'on');
    timehistory = plot(app.TimeHistoryAxes,app.Wavedata.(strcat('ch',(num2str(app.TimeHistTimeDropDown.Value)))),y);
    hold(app.TimeHistoryAxes,'off');
    roundedchannel = int64(lbvalue);
    analysisrow = [roundedchannel,cell(1),mean(y), min(y),max(y),std(y)];
    app.StatsTable.Data = [app.StatsTable.Data;analysisrow];
    rowname{value==lbvalue} = app.Wavedata.headers{lbvalue};
    s = uistyle('BackgroundColor',timehistory.Color);
    addStyle(app.StatsTable,s,'cell',[find(value==lbvalue),2]);
end
app.StatsTable.RowName = rowname;

pkg.fun.Save_UI_Axes.copyUIAxes(app.TimeHistoryAxes);
savefig(strcat('+output/TimeHistory_',(app.Wavedata.headers{value}),'.fig')); 
end
