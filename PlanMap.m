classdef PlanMap < handle
    %PlanMap 用于管理并显示地图
    %   此处显示详细说明

    properties
        gridMap
        oringin = [0, 0] % 原点经纬度
        resolution = 1 % 分辨率 米
        flg %figure 对象
        e % 东坐标
        n % 北坐标
    end

    methods
        function obj = PlanMap(e, n)
            %PlanMap 构造此类的实例
            %   e: 东坐标
            %   n: 北坐标
            obj.gridMap = zeros(n, e);
            obj.flg = figure;
            obj.e = e;
            obj.n = n;
        end 

        % 通过赋值的方式设置地图
        function etMap(obj, map)
            obj.gridMap = map;
        end

        % 随机生成地图，值为-1 0 1，通过e n设置地图大小
        function randomMap(obj)
            obj.gridMap = randi([-1, 1], obj.n, obj.e);
        end

%        % 生成地形图，通过e n设置地图大小，值为 0 1， 使用变量控制0的比例，并且让0有连续性
%        function terrainMap(obj, zeroRate)
%            obj.gridMap = zeros(obj.n, obj.e);
%            for i = 1:obj.n
%                for j = 1:obj.e
%                    if rand() < zeroRate
%                        obj.gridMap(i, j) = 0;
%                    else
%                        obj.gridMap(i, j) = 1;
%                    end
%                end
%            end
%        end
        % 生成地形图，通过e n设置地图大小，值为 0 1， 使用变量控制0的比例，并且让0呈现小岛状分布
        function terrainMap(obj, zeroRate, meanZeroPerIsland)
            obj.gridMap = ones(obj.n, obj.e);
            totalZeros = round(zeroRate * obj.n * obj.e);
            numIslands = max(1, round(totalZeros / meanZeroPerIsland)); % 根据需要调整每个小岛的大小
            
            for k = 1:numIslands
                centerRow = randi(obj.n);
                centerCol = randi(obj.e);
                radius = randi([1, max(1,round(sqrt(meanZeroPerIsland/pi)))]); % 小岛半径可调
                for i = max(centerRow - radius, 1):min(centerRow + radius, obj.n)
                    for j = max(centerCol - radius, 1):min(centerCol + radius, obj.e)
                        obj.gridMap(i, j) = 0;
                    end
                end
            end
        end

        % 使用imagesc函数显示地图，-1 0 1 分别为灰色 黑色 白色
        function showMap(obj)
            obj.flg;
            imagesc([0 obj.e * obj.resolution], [0 obj.n * obj.resolution], obj.gridMap);
            % colormap(gray);
            colormap([0 0 0; 0.5 0.5 0.5; 1 1 1]);
            colorbar('Ticks', [-1, 0, 1], 'TickLabels', {'unknow', 'obstacle', 'free'});
            axis equal;
            xlabel('east (m)');
            ylabel('north (m)');
            set(gca, 'YDir', 'normal'); % 让 y 轴指向上
        end

        % 绘制连接起点和终点的线，通过start和end点的坐标
        function drawLine(obj, start, end_)
            obj.flg;
            hold on;
            line([start(1), end_(1)], [start(2), end_(2)], 'Color', 'r', 'LineWidth', 2);
        end



    end
end