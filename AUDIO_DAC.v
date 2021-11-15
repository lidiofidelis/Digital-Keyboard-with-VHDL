module AUDIO_DAC (	//	Memory Side
					//	Audio Side
					oAUD_BCK,
					oAUD_DATA,
					oAUD_LRCK,
					//	Control Signals
					dados,
					vetor,
					endereco,
					oitava,
					frequencia,
				   iCLK_18_4,
					iRST_N	);				

parameter	REF_CLK			=	18432000;	//	18.432	MHz
//parameter	SAMPLE_RATE		=	96000;		//	48		KHz
parameter	DATA_WIDTH		=	16;			//	16		Bits
parameter	CHANNEL_NUM		=	2;			//	Dual Channel

wire	[8:0] SIN_SAMPLE_DATA;

output				oAUD_DATA;
output				oAUD_LRCK;
output	reg		oAUD_BCK;
//	Control Signals


input		[15:0]	dados;
input		[8:0]		vetor;
input		[4:0]		oitava;
output	[8:0]		endereco;
input		[16:0]	frequencia;


input			iCLK_18_4;
input			iRST_N;
//	Internal Registers and Wires
reg		[3:0]	BCK_DIV;
reg		[8:0]	LRCK_1X_DIV;
reg		[3:0]	SEL_Cont;
////////	DATA Counter	////////
reg		[8:0]	SIN_Cont;

////////////////////////////////////
wire		[DATA_WIDTH-1:0]	Sin_Out;

wire		[16:0]			SAMPLE_RATE;

reg							LRCK_1X;

////////////	AUD_BCK Generator	//////////////
always@(posedge iCLK_18_4 or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		BCK_DIV	<=	0;
		oAUD_BCK	<=	0;
	end
	else
	begin
		if(BCK_DIV >= REF_CLK/(SAMPLE_RATE*DATA_WIDTH*CHANNEL_NUM*2)-1 )
		begin
			BCK_DIV <= 0;
			oAUD_BCK	<=	~oAUD_BCK;
		end
		else
		BCK_DIV <= BCK_DIV + 1'b1;
	end
end
//////////////////////////////////////////////////
////////////	AUD_LRCK Generator	//////////////
always@(posedge iCLK_18_4 or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		LRCK_1X_DIV	<=	0;
		LRCK_1X		<=	0;
	end
	else
	begin
		//	LRCK 1X
		if(LRCK_1X_DIV >= REF_CLK/(SAMPLE_RATE*2)-1 )
		begin
			LRCK_1X_DIV	<=	0;
			LRCK_1X	<=	~LRCK_1X;
		end
		else
		LRCK_1X_DIV <= LRCK_1X_DIV + 1'b1;	
	end
end
assign	oAUD_LRCK	=	LRCK_1X;
//////////////////////////////////////////////////
//////////	Sin LUT ADDR Generator	//////////////

assign	SIN_SAMPLE_DATA	=	vetor;

always@(negedge LRCK_1X or negedge iRST_N)
begin
	if(!iRST_N)
	SIN_Cont	<=	0;
	else
	begin
		if(SIN_Cont < SIN_SAMPLE_DATA - 1)
		SIN_Cont	<=	SIN_Cont + oitava;
		else
		SIN_Cont	<=	0;
	end
end
//////////////////////////////////////////////////


//////////////////////////////////////////////////
//////////	16 Bits PISO MSB First	//////////////
always@(negedge oAUD_BCK or negedge iRST_N)
begin
	if(!iRST_N)
	SEL_Cont	<=	0;
	else
	SEL_Cont	<=	SEL_Cont + 1'b1;
end
assign	oAUD_DATA	=	Sin_Out[~SEL_Cont];												
//////////////////////////////////////////////////
////////////	Sin Wave ROM Table	//////////////

assign	Sin_Out	=	dados;

assign	endereco	=	SIN_Cont;

assign	SAMPLE_RATE	=	frequencia;

//////////////////////////////////////////////////

endmodule
