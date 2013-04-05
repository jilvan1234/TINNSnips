-- test_math_matrix.lua

package.path = package.path..";../?.lua"

local ffi = require("ffi");

local math_matrix = require("math_matrix");
local mat4 = math_matrix.mat4;
local mat3 = math_matrix.mat3;
local vec4 = math_matrix.vec4;
local vec3 = math_matrix.vec3;

local test_vec = function()
	local v1 = vec4(0.125, 0.25, 0.5, 1);
	print("v1: ", v1);

	local m1 = mat4({v1, v1, v1, v1})
	print("m1:")
	print(m1);

	print(vec3(1,1,1):normal());

	local xaxis = vec3(1,0,0);
	local yaxis = vec3(0,1,0);
	local zaxis = xaxis:cross(yaxis);

	print("zaxis: ", zaxis);
end

local test_normal = function()
--	local p1 = vec3(-37.262199401855, -17.623699188232, 0);
--	local p2 = vec3(-40.927501678467, -24.531000137329, 0);
--	local p3 = vec3(-35.355350494385, -14.64465045929, 0);

	local p1 = vec3(0,7,0);
	local p2 = vec3(0,0,0);
	local p3 = vec3(5,0,0);

	local n = math_matrix.PlaneNormal(p1, p2, p3);

	print(n);

	print("axis normal")
	print(math_matrix.PlaneNormal(vec3(1,0,0), vec3(0,1,0), vec3(0,0,1)));
end


local test_matrix= function()
	local identity = mat3(1);

	local col0 = identity[0];
	print("col0: ", col0:rows(), col0:columns(), ffi.typeof(col0));
	print(col0);

	print(identity *1);

	local m1 = mat3({{0,0,0},{0,0,0},{5,10,1}});
	print("m1:");
	print(m1);

	print("identity * m1");
	print(identity*m1);
end

local test_matrix1 = function()
	local identity = mat3(1);
	print("identity: ");
	print(identity);

	print("identity * 3.2: ");
	print(identity*3.2);

	local m2 = mat3(1);

	print("identity * m2: ")
	print(identity*m2);

	local m3 = mat3({{1,2,3},{4,5,6},{7,8,9}});
	print("m3");
	print(m3);

	local c1 = m3[1];
	print("column 1")
	for i=0,2 do
		print(c1[i]);
	end

	print("m3 * identity");
	print(m3 * identity);


	local v1 = vec3(6,7,8);
	print("v1")
	print(v1);
	print("v1[0]: ", v1[0]);
	print("v1[1]: ", v1[1]);
	print("v1[2]: ", v1[2]);

	local v2 = v1 * identity;


	print("v1 * identity");
	print(v2);

	print("identity * v1");
	print(identity*v1);
end


local test_matrix2 = function()
	local mat3x2 = math_matrix.make_matrix_kind(ffi.typeof("float"), 3, 2);
	local mat2 = math_matrix.make_matrix_kind(ffi.typeof("float"), 2,2);
	local m1 = mat3x2({
		{8,1},
		{7,3},
		{6,2}
		})
	local m2 = mat2({{0,1},{1,0}});

	local m3 = m1*m2;

	print(m3);
end

local test_cubicSpline = function()
	local G = mat4({
		{0,3,0,1},
		{3,0,0,1},
		{3,0,0,0},
		{3,0,0,0}
		})

	-- cubic hermite
	local M = mat4({
		{2, -2, 1, 1},
		{-3, 3, -2, 1},
		{0,0,1,0},
		{1,0,0,0}
		})
	local S = mat4({
		{1,0,0,0},
		{0,1,0,0},
		{0,0,1,0},
		{0,0,5,1}
		})

	local ufunc = function(u)
		return vec4(u*u*u, u*u, u, 1);
	end

	local TS = M * G;
	local U = ufunc(0.5);

	local res = U * TS * S;

	--print(TS);
	--print(U);
	print(res);
end

local test_swizzling = function()
	print("SWIZZLING");
	for idx in math_matrix.swizzlit("bgb") do
		print(idx);
	end

	local color1 = vec3(255, 13, 200);
	print("color1");
	print(color1);

	print("bgr");
	print(color1.bgr);

	print("ggrr")
	print(color1.ggrr);

	local mvec7 = math_matrix.make_matrix_kind(ffi.typeof("float"), 1, 7);
	print("mvec7 kind: ", ffi.typeof(mvec7));

	print("xyrgstz")
	local swizzled = color1.xyrgstz;
	print(swizzled);
	print("TYPE of SWIZ: ", ffi.typeof(swizzled));


	local t1 = ffi.typeof("struct {float x,y,z;}");
	local t2 = ffi.typeof("struct {float x,y,z;}");

	print("t1: ", t1);
	print("t2: ", t2);

	print("t1 == t2: ", t1 == t2);
end

--test_vec();
test_normal();
--test_matrix();
--test_matrix1();
--test_matrix2();
--test_swizzling();

--test_cubicSpline();
