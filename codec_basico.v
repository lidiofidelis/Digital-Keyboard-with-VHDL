module codec_basico(

	//////// CLOCK //////////
	CLOCK_50,

	//////// Audio //////////
	AUD_ADCDAT,
	AUD_ADCLRCK,
	AUD_BCLK,
	AUD_DACDAT,
	AUD_DACLRCK,
	AUD_XCK,
	
	//////// I/O /////////
		
	RESET,
	
	DADOS_I2C,
	ENDERECOS_I2C,
	
	DADOS_AUDIO,
	ENDERECOS_AUDIO,
	INCREMENTO_AUDIO,
	LARGURA_ENDERECOS_AUDIO,
	TAXA_AMOSTRAGEM,

	//////// I2C for Audio //////////
	I2C_SCLK,
	I2C_SDAT

);
//=======================================================
//  PARAMETER declarations
//=======================================================

//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK //////////
input		          		CLOCK_50;

//////////// Audio //////////
input		          		AUD_ADCDAT;
inout		          		AUD_ADCLRCK;
inout		          		AUD_BCLK;
output		        		AUD_DACDAT;
inout		          		AUD_DACLRCK;
output		        		AUD_XCK;

//////////// I/O /////////////

input							RESET;

input			[15:0]		DADOS_I2C;
output		[3:0]			ENDERECOS_I2C;

input			[15:0]		DADOS_AUDIO;
input			[8:0]			LARGURA_ENDERECOS_AUDIO;
input			[4:0]			INCREMENTO_AUDIO;
output		[8:0]			ENDERECOS_AUDIO;
input			[16:0]		TAXA_AMOSTRAGEM;

//////////// I2C for Audio //////////
output		        		I2C_SCLK;
inout		          		I2C_SDAT;

///////////////////////////////////////////////////////////////////
//=============================================================================
// REG/WIRE declarations
//=============================================================================

wire		   DLY_RST;

//	For Audio CODEC
wire		   AUD_CTRL_CLK;	//	For Audio Controller


//=============================================================================
// Structural coding
//=============================================================================
// initial //
//
 
    		         
assign AUD_ADCLRCK    	= 1'bz;     					
    					
assign AUD_DACLRCK 		= 1'bz;     					
assign AUD_DACDAT 		= 1'bz;     					
assign AUD_BCLK 		   = 1'bz;     						
assign AUD_XCK 		   = 1'bz;     						
   						
assign I2C_SDAT 		   = 1'bz;     						
assign I2C_SCLK		   = 1'bz;			

assign AUD_XCK	    		=	AUD_CTRL_CLK;
assign AUD_ADCLRCK		=	AUD_DACLRCK;


//Reset Delay Timer
Reset_Delay			r0	(.iCLK(CLOCK_50),.oRESET(DLY_RST));

VGA_Audio_PLL 		p1	(.areset(~DLY_RST | RESET),.inclk0(CLOCK_50),.c0(AUD_CTRL_CLK));

					
//Audio CODEC DECODER setting
I2C_AV_Config 		u2	(//Host Side
							.iCLK(CLOCK_50),
							.iRST_N(DLY_RST & ~RESET),
							//I2C Side
							.I2C_SCLK(I2C_SCLK),
							.I2C_SDAT(I2C_SDAT),
							.endereco_i2c(ENDERECOS_I2C),
							.dado_i2c(DADOS_I2C));

AUDIO_DAC 			u3	(//Audio Side
							.oAUD_BCK(AUD_BCLK),
							.oAUD_DATA(AUD_DACDAT),
							.oAUD_LRCK(AUD_DACLRCK),
							//Control Signals
							.dados(DADOS_AUDIO),
							.vetor(LARGURA_ENDERECOS_AUDIO),
							.endereco(ENDERECOS_AUDIO),
							.oitava(INCREMENTO_AUDIO),
							.frequencia(TAXA_AMOSTRAGEM),
				         .iCLK_18_4(AUD_CTRL_CLK),
							.iRST_N(DLY_RST & ~RESET));
endmodule
