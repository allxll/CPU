`timescale 1ns/1ps

module Inst_Mem (
	input [31:0] addr,
	output [31:0] data
);

localparam ROM_SIZE = 256;
(* rom_style = "distributed" *) reg [31:0] ROMDATA[ROM_SIZE-1:0];

assign data = (addr[30:2] < ROM_SIZE)?ROMDATA[addr[30:2]]:32'b0;

integer i;
initial begin
		ROMDATA[0]  <=  32'h08000003;
		ROMDATA[1] <=   32'h0800002d;
        ROMDATA[2] <=   32'h080000a5;
        ROMDATA[3] <=   32'h3c084000;
        ROMDATA[4] <=   32'h35080008;
        ROMDATA[5] <=   32'had000000;
        ROMDATA[6] <=   32'h3c0affff;
        ROMDATA[7] <=   32'h354affe0;
        ROMDATA[8] <=   32'had0afff8;
        ROMDATA[9] <=   32'h354affff;
        ROMDATA[10] <=  32'had0afffc;
        ROMDATA[11] <=  32'h20090000;
        ROMDATA[12] <=  32'had090000;
        ROMDATA[13] <=  32'h00001020;
        ROMDATA[14] <=  32'h8d100018;
        ROMDATA[15] <=  32'h32100008;
        ROMDATA[16] <=  32'h1e000004;
        ROMDATA[17] <=  32'h0800000e;
        ROMDATA[18] <=  32'h8d040014;
        ROMDATA[19] <=  32'h20420001;
        ROMDATA[20] <=  32'h0800000e;
        ROMDATA[21] <=  32'had000018;
        ROMDATA[22] <=  32'h1040fffb;
        ROMDATA[23] <=  32'h8d050014;
        ROMDATA[24] <=  32'h00808020;
        ROMDATA[25] <=  32'h00a08820;
        ROMDATA[26] <=  32'h00105020;
        ROMDATA[27] <=  32'h00118020;
        ROMDATA[28] <=  32'h000a8820;
        ROMDATA[29] <=  32'h0230582a;
        ROMDATA[30] <=  32'h11600003;
        ROMDATA[31] <=  32'h00105020;
        ROMDATA[32] <=  32'h00118020;
        ROMDATA[33] <=  32'h000a8820;
        ROMDATA[34] <=  32'h02308822;
        ROMDATA[35] <=  32'h0211582a;
        ROMDATA[36] <=  32'h11600001;
        ROMDATA[37] <=  32'h08000022;
        ROMDATA[38] <=  32'h12200001;
        ROMDATA[39] <=  32'h0800001a;
        ROMDATA[40] <=  32'had100010;
        ROMDATA[41] <=  32'had100004;
        ROMDATA[42] <=  32'h20090003;
        ROMDATA[43] <=  32'had090000;
        ROMDATA[44] <=  32'h1800ffff;
        ROMDATA[45] <=  32'hafa90004;
        ROMDATA[46] <=  32'hafa80008;
        ROMDATA[47] <=  32'h00004020;
        ROMDATA[48] <=  32'h3c084000;
        ROMDATA[49] <=  32'h8d090008;
        ROMDATA[50] <=  32'h3129fff9;
        ROMDATA[51] <=  32'had090008;
		ROMDATA[52] <=  32'h23bd0024;
		ROMDATA[53] <=  32'hafb00000;
		ROMDATA[54] <=  32'hafa4fffc;
		ROMDATA[55] <=  32'hafa5fff8;
		ROMDATA[56] <=  32'hafaafff4;
		ROMDATA[57] <=  32'hafa2fff0;
		ROMDATA[58] <=  32'hafa3ffec;
		ROMDATA[59] <=  32'hafbfffe8;
		ROMDATA[60] <=  32'h8d100014;
		ROMDATA[61] <=  32'h00108202;
		ROMDATA[62] <=  32'h2003000e;
		ROMDATA[63] <=  32'h12030006;
		ROMDATA[64] <=  32'h2003000d;
		ROMDATA[65] <=  32'h12030007;
		ROMDATA[66] <=  32'h2003000b;
		ROMDATA[67] <=  32'h12030008;
		ROMDATA[68] <=  32'h20030007;
		ROMDATA[69] <=  32'h12030009;
		ROMDATA[70] <=  32'h20100d00;
		ROMDATA[71] <=  32'h3087000f;
		ROMDATA[72] <=  32'h08000052;
		ROMDATA[73] <=  32'h20100b00;
		ROMDATA[74] <=  32'h00053902;
		ROMDATA[75] <=  32'h08000052;
		ROMDATA[76] <=  32'h20100700;
		ROMDATA[77] <=  32'h30a7000f;
		ROMDATA[78] <=  32'h08000052;
		ROMDATA[79] <=  32'h20100e00;
		ROMDATA[80] <=  32'h00043902;
        ROMDATA[81] <=  32'h08000052;
		ROMDATA[82] <=  32'h0c000056;
		ROMDATA[83] <=  32'h020a8025;
		ROMDATA[84] <=  32'had100014;
		ROMDATA[85] <=  32'h08000097;
		ROMDATA[86] <=  32'h00001020;
		ROMDATA[87] <=  32'h10e2001f;
		ROMDATA[88] <=  32'h20420001;
		ROMDATA[89] <=  32'h10e2001f;
		ROMDATA[90] <=  32'h20420001;
		ROMDATA[91] <=  32'h10e2001f;
		ROMDATA[92] <=  32'h20420001;
		ROMDATA[93] <=  32'h10e2001f;
		ROMDATA[94] <=  32'h20420001;
		ROMDATA[95] <=  32'h10e2001f;
		ROMDATA[96] <=  32'h20420001;
		ROMDATA[97] <=  32'h10e2001f;
		ROMDATA[98] <=  32'h20420001;
		ROMDATA[99] <=  32'h10e2001f;
		ROMDATA[100] <= 32'h20420001;
		ROMDATA[101] <= 32'h10e2001f;
		ROMDATA[102] <= 32'h20420001;
		ROMDATA[103] <= 32'h10e2001f;
		ROMDATA[104] <= 32'h20420001;
		ROMDATA[105] <= 32'h10e2001f;
		ROMDATA[106] <= 32'h20420001;
		ROMDATA[107] <= 32'h10e2001f;
		ROMDATA[108] <= 32'h20420001;
		ROMDATA[109] <= 32'h10e2001f;
		ROMDATA[110] <= 32'h20420001;
        ROMDATA[111] <= 32'h10e2001f;
        ROMDATA[112] <= 32'h20420001;
        ROMDATA[113] <= 32'h10e2001f;
        ROMDATA[114] <= 32'h20420001;
        ROMDATA[115] <= 32'h10e2001f;
        ROMDATA[116] <= 32'h20420001;
        ROMDATA[117] <= 32'h10e2001f;
        ROMDATA[118] <= 32'h03e00008;
        ROMDATA[119] <= 32'h200a0001;
        ROMDATA[120] <= 32'h03e00008;
        ROMDATA[121] <= 32'h200a004f;
        ROMDATA[122] <= 32'h03e00008;
        ROMDATA[123] <= 32'h200a0012;
        ROMDATA[124] <= 32'h03e00008;
        ROMDATA[125] <= 32'h200a0006;
        ROMDATA[126] <= 32'h03e00008;
        ROMDATA[127] <= 32'h200a004c;
        ROMDATA[128] <= 32'h03e00008;
        ROMDATA[129] <= 32'h200a0024;
        ROMDATA[130] <= 32'h03e00008;
        ROMDATA[131] <= 32'h200a0020;
        ROMDATA[132] <= 32'h03e00008;
        ROMDATA[133] <= 32'h200a000f;
        ROMDATA[134] <= 32'h03e00008;
        ROMDATA[135] <= 32'h200a0000;
        ROMDATA[136] <= 32'h03e00008;
        ROMDATA[137] <= 32'h200a0004;
        ROMDATA[138] <= 32'h03e00008;
        ROMDATA[139] <= 32'h200a0008;
        ROMDATA[140] <= 32'h03e00008;
        ROMDATA[141] <= 32'h200a0060;
        ROMDATA[142] <= 32'h03e00008;
        ROMDATA[143] <= 32'h200a0031;
        ROMDATA[144] <= 32'h03e00008;
        ROMDATA[145] <= 32'h200a0042;
        ROMDATA[146] <= 32'h03e00008;
        ROMDATA[147] <= 32'h200a0030;
        ROMDATA[148] <= 32'h03e00008;
        ROMDATA[149] <= 32'h200a0038;
        ROMDATA[150] <= 32'h03e00008;
        ROMDATA[151] <= 32'h23bdffdc;
        ROMDATA[152] <= 32'h8fbf000c;
        ROMDATA[153] <= 32'h8fa30010;
        ROMDATA[154] <= 32'h8fa20014;
        ROMDATA[155] <= 32'h8faa0018;
        ROMDATA[156] <= 32'h8fa5001c;
        ROMDATA[157] <= 32'h8fa40020;
        ROMDATA[158] <= 32'h8fb00024;
        ROMDATA[159] <= 32'h235afffc;
        ROMDATA[160] <= 32'h35290002;
        ROMDATA[161] <= 32'had090008;
        ROMDATA[162] <= 32'h8fa90004;
        ROMDATA[163] <= 32'h8fa80008;
        ROMDATA[164] <= 32'h03400008;
        ROMDATA[165] <= 32'h03400008;
	    for (i=166;i<ROM_SIZE;i=i+1) begin
            ROMDATA[i] <= 32'b0;
        end
end
endmodule