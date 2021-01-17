close all;

data = load('data.csv');
tf_cnt = 5;
tf_unit = 'minutes';
pip = 1e-4;
waiting_cnt = 3*60/tf_cnt;

s_tf = 60*2/tf_cnt;
m_tf = 60*8/tf_cnt;
l_tf = 60*24/tf_cnt;
vl_tf = 60*24*5/tf_cnt;

% s_tf = 50;
% m_tf = 300;
% l_tf = 500;
% vl_tf = 1000;

diff_val = data(:,6);
diff_val = diff(diff_val);
diff_val = diff_val * 1/pip;
hour = 1:12:length(data);

avg_val = zeros(length(diff_val),1);
increased_pip = zeros(length(diff_val),1);
decreased_pip = zeros(length(diff_val),1);
for ii = waiting_cnt:length(diff_val)
    window = diff_val(ii-waiting_cnt+1:ii);
    accum = zeros(waiting_cnt,1);
    sum_val = 0;
    for jj=1:waiting_cnt
        sum_val = sum_val + window(jj);
        accum(jj) = sum_val;
    end
    avg_val(ii) = mean(window);
    increased_pip(ii) = max(accum);
    decreased_pip(ii) = min(accum);
end

%% Find cmf
x1 = sort(increased_pip(end - s_tf + 1:end), 'ascend');
p1 = zeros(length(x1),1);
for ii=1:length(x1)
    p1(ii) = sum(x1<=x1(ii)) / length(x1);
end
optimal_inc_pip = x1(p1 == max(p1(p1<0.7)))

x2 = sort(decreased_pip(end - s_tf + 1:end), 'ascend');
p2 = zeros(length(x2),1);
for ii=1:length(x2)
    p2(ii) = sum(x2<=x2(ii)) / length(x2);
end
optimal_dec_pip = x2(p2 == min(p2(p2>0.3)))

%% Plot
fig = figure;
sgtitle(sprintf('pip - tf %d %s - wait until closing pos %d candles - 1h = %dcd - 3h = %dcd - 1d = %dcd - 3d = %dcd', ...
    tf_cnt, tf_unit, waiting_cnt, 60/tf_cnt, 60*3/tf_cnt, 60*24/tf_cnt, 60*24*3/tf_cnt));
subplot(2,5,[1,2]); hold on; grid on;
plot(diff_val(end-vl_tf+1:end));
plot(increased_pip(end-vl_tf+1:end));
plot(decreased_pip(end-vl_tf+1:end));
plot(avg_val(end-vl_tf+1:end));
legend('diff', 'increased pip','decreased pip', 'avg val');
subplot(2,5,3);
histogram(increased_pip(end - s_tf + 1:end), floor(range(increased_pip(end - s_tf + 1:end))) + 1);
legend(sprintf('inc - last %d candles', s_tf));
subplot(2,5,4);
histogram(increased_pip(end - m_tf + 1:end), floor(range(increased_pip(end - m_tf + 1:end))) + 1);
legend(sprintf('inc - last %d candles', m_tf));
subplot(2,5,5);
histogram(increased_pip(end - l_tf + 1:end), floor(range(increased_pip(end - l_tf + 1:end))) + 1);
legend(sprintf('inc - last %d candles', l_tf));
subplot(2,5,6);
histogram(increased_pip(end - vl_tf + 1:end), floor(range(increased_pip(end - vl_tf + 1:end))) + 1);
legend(sprintf('inc - last %d candles', vl_tf));
subplot(2,5,7);
histogram(decreased_pip(end - s_tf + 1:end), floor(range(decreased_pip(end - s_tf + 1:end))) + 1);
legend(sprintf('dec - last %d candles', s_tf));
subplot(2,5,8);
histogram(decreased_pip(end - m_tf + 1:end), floor(range(decreased_pip(end - m_tf + 1:end))) + 1);
legend(sprintf('dec - last %d candles', m_tf));
subplot(2,5,9);
histogram(decreased_pip(end - l_tf + 1:end), floor(range(decreased_pip(end - l_tf + 1:end))) + 1);
legend(sprintf('dec - last %d candles', l_tf));
subplot(2,5,10);
histogram(decreased_pip(end - vl_tf + 1:end), floor(range(decreased_pip(end - vl_tf + 1:end))) + 1);
legend(sprintf('dec - last %d candles', vl_tf));

fig = figure;
sgtitle(sprintf('pip - tf %d %s - wait until closing pos %d candles - 1h = %dcd - 3h = %dcd - 1d = %dcd - 3d = %dcd', ...
    tf_cnt, tf_unit, waiting_cnt, 60/tf_cnt, 60*3/tf_cnt, 60*24/tf_cnt, 60*24*3/tf_cnt));
subplot(2,5,[1,2]); hold on; grid on;
plot(diff_val(end-vl_tf+1:end));
plot(increased_pip(end-vl_tf+1:end));
plot(decreased_pip(end-vl_tf+1:end));
plot(avg_val(end-vl_tf+1:end));
legend('diff', 'increased pip','decreased pip', 'avg val');
subplot(2,5,3); grid on;
probplot(increased_pip(end - s_tf + 1:end));
legend(sprintf('inc - last %d candles', s_tf));
subplot(2,5,4); grid on;
probplot(increased_pip(end - m_tf + 1:end));
legend(sprintf('inc - last %d candles', m_tf));
subplot(2,5,5); grid on;
probplot(increased_pip(end - l_tf + 1:end));
legend(sprintf('inc - last %d candles', l_tf));
subplot(2,5,6); grid on;
probplot(increased_pip(end - vl_tf + 1:end));
legend(sprintf('inc - last %d candles', vl_tf));
subplot(2,5,7); grid on;
probplot(decreased_pip(end - s_tf + 1:end));
legend(sprintf('dec - last %d candles', s_tf));
subplot(2,5,8); grid on;
probplot(decreased_pip(end - m_tf + 1:end));
legend(sprintf('dec - last %d candles', m_tf));
subplot(2,5,9); grid on;
probplot(decreased_pip(end - l_tf + 1:end));
legend(sprintf('dec - last %d candles', l_tf));
subplot(2,5,10); grid on;
probplot(decreased_pip(end - vl_tf + 1:end));
legend(sprintf('dec - last %d candles', vl_tf));
