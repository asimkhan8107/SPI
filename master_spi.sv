module master_spi(
    input clk, newd, rst,
    input [11:0] din,
    output reg sclk, cs, mosi
    );
    
    // comp = complete
    typedef enum bit [1:0] {idle = 2'b00, enable = 2'b01, send = 2'b10, comp = 2'b11} state_type;
    state_type state = idle;
    
    int countc = 0;
    int count = 0;
    
    ////// Clock generation
    always_ff@(posedge clk)
    begin
        if(rst)
        begin
            countc <= 0;
            sclk <= 1'b0;
        end
        else
        begin
            if(countc < 10)     // fclk / 20
                countc <= countc + 1;
            else
            begin
                countc <= 0;
                sclk = ~sclk;
            end   
        end
    end
    
    ///// state machine
    reg [11:0] temp;
    
    always_ff@(posedge sclk)
    begin
        if(rst) 
        begin
            cs <= 1'b1;
            mosi <= 1'b0;
        end
        else
        begin
            case(state)
                idle:
                begin
                    if(newd)
                    begin
                        state <= send;
                        temp <= din;
                        cs <= 1'b0;
                    end
                    else
                    begin
                        state <= idle;
                        temp <= 8'h00;
                    end
                end
                //////////////////////
                send:
                begin
                    if(count <= 11)
                    begin
                        mosi <= temp[count];    //sending lsb fisrt
                        count <= count + 1;
                    end
                    else
                    begin
                        count <= 0;
                        state <= idle;
                        cs <= 1'b1;
                        mosi <= 1'b0;
                    end
                end  
                default : state <= idle;           
            endcase
        end
    end 
endmodule
