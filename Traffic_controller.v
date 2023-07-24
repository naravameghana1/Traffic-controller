`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2023 11:50:49 PM
// Design Name: 
// Module Name: Traffic_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// Define the states of the controller. 
    `define S0 4'd0 
    `define S1 4'd1 
    `define S2 4'd2 
    `define S3 4'd3 
    `define S4 4'd4 
    `define S5 4'd5 
    `define S6 4'd6 
    `define S7 4'd7 
    `define S8 4'd8 
    `define S9 4'd9 
    `define S10 4'd10 
    `define S11 4'd11 
    `define S12 4'd12 
    
   
    `define load_cnt2 9'd449 
     // This is the Timer 1 count value in units of 0.1 s providing 45 s delay. 
    `define load_cnt3 6'd49 
     // This is the Timer 2 count value in units of 0.1 s providing 5 s delay. 
    `define load_cnt4 8'd249 
     // This is the Timer 3 count value in units of 0.1 s providing 25 s delay. 
    `define load_cnt5 3'd4 
     // This is the Timer 4 count value in units of 0.1 s providing 0.5 s delay. 
     // Change these if you desire different timings. 
module traffic_controller ( clk, 
     reset_n, 
     MR1, // Main Red 1 
     MR2, // Main Red 2 
     MY1, // Main Yellow 1 
     MY2, // Main Yellow 2 
     MG1, // Main Green 1 
     MG2, // Main Green 2 
     MLT1, // Main Left 1 
     MLT2, // Main Left 2 
     SR1, // Side Red 1 
     SR2, // Side Red 2 
     SY1, // Side Yellow 1 
     SY2, // Side Yellow 2 
     SG1, // Side Green 1 
     SG2, // Side Green 2 
     SLT1, // Side Left 1 
     SLT2, // Side Left 2 
     blink 
); 
// Declare inputs/outputs. 
    input clk ; 
    input reset_n ; 
    input blink ; 
    output MG1 ; // Traffic lights, main green, 
    output MG2 ; // etc. are declared as outputs. 
    output MY1 ; 
    output MY2 ; 
    output MR1 ; 
    output MR2 ; 
    output MLT1 ; //Outputs for Main road left turn. 
    output MLT2 ; 
    output SR1 ; 
    output SR2 ; 
    output SY1 ; 
    output SY2 ; 
    output SG1 ; 
    output SG2 ; 
    output SLT1 ; //Outputs for Side road left turn. 
    output SLT2 ; 
     
    // Declare nets (combinational circuit outputs). 
    wire [8:0] cnt2_next; 
    wire [5:0] cnt3_next; 
    wire [7:0] cnt4_next; 
    wire [2:0] cnt5_next; 
    // Declare registered signals. 
    //reg [21:0] cnt1_reg ; 
    reg [8:0] cnt2_reg ; 
    reg [5:0] cnt3_reg ; 
    reg [7:0] cnt4_reg ; 
    reg [2:0] cnt5_reg ; 
    reg start_timer_1 ;  //45
    reg start_timer_2 ;  //25
    reg start_timer_3 ;  //5
    reg [3:0] state ; 
    reg MR1 ; 
    reg MR2 ; 
    reg MY1 ; 
    reg MY2 ; 
    reg MG1 ; 
    reg MG2 ; 
    reg MLT1 ; 
    reg MLT2 ; 
    reg SR1 ; 
    reg SR2 ; 
    reg SY1 ; 
    reg SY2 ; 
    reg SG1 ; 
    reg SG2 ; 
    reg SLT1 ; 
    reg SLT2 ; 
    // Timer implementation
    /* 
    This is the Timer 1, programmed for 45 s in order to facilitate the smooth running of the main road traffic. 
    */ 
    
    assign cnt2_next = cnt2_reg + 1 ; // Pre-increment the counter. 
    always @ (posedge clk or negedge reset_n) 
    begin 
    if (reset_n == 1'b0) 
        cnt2_reg <= 9'd0 ; // Initialize when the system is reset. 
    else if (cnt2_reg == `load_cnt2) 
        cnt2_reg <= 9'd0 ; // Reset if terminal count is reached. 
    else if (start_timer_1 == 1'b1) 
        cnt2_reg <= cnt2_next ; 
    // 45 s timer - advance the count once if 
    // the timer is still running. 
    else 
        cnt2_reg <= cnt2_reg ; // Otherwise, don't disturb. 
    end 
    /* 
     This is the Timer 2, programed for 5 s (activating yellow lights) for the 
     smooth transition while switching from one traffic to another. 
    */ 
    assign cnt3_next = cnt3_reg + 1 ; // Pre-increment the counter. 
    always @ (posedge clk or negedge reset_n) 
    begin 
     if (reset_n == 1'b0) 
        cnt3_reg <= 6'd0 ; // Initialize when the system is reset. 
     else if (cnt3_reg == `load_cnt3) 
        cnt3_reg <= 6'd0 ; // Reset if terminal count is reached. 
     else if (start_timer_2 == 1'b1) 
        cnt3_reg <= cnt3_next ; 
     // 5 s timer - advance the count once if the timer is still running. 
     else 
        cnt3_reg <= cnt3_reg ; // Otherwise, don't disturb. 
    end 
    // This is the Timer 3, programed for 25 s delay, used for

    assign cnt4_next = cnt4_reg + 1 ; // Pre-increment the counter. 
    always @(posedge clk or negedge reset_n) 
    begin 
     if (reset_n == 1'b0) 
        cnt4_reg <= 8'd0 ; // Initialize when the system is reset. 
     else if (cnt4_reg == `load_cnt4) 
        cnt4_reg <= 8'd0 ; // Reset if terminal count is reached. 
     else if (start_timer_3 == 1'b1) 
        cnt4_reg <= cnt4_next ; 
     // 25 s timer - advance the count once if the timer is still running. 
     else
        cnt4_reg <= cnt4_reg ; // Otherwise, don't disturb. 
     end 
     // This is the Timer 4, programed for 0.5 s delay, used for blinking of all 
     
     assign cnt5_next = cnt5_reg + 1 ; // Pre-increment the counter. 
     always @ (posedge clk or negedge reset_n) 
     begin 
      if (reset_n == 1'b0) 
        cnt5_reg <= 3'd0 ; // Initialize when the system is reset. 
      else if (cnt5_reg == `load_cnt5) 
        cnt5_reg <= 3'd0 ; // Reset if terminal count is reached. 
      else if (blink == 1'b1) 
        cnt5_reg <= cnt5_next ; 
     // Advance the count once if the timer is still running. 
      else 
        cnt5_reg <= cnt5_reg ; // Otherwise, don't disturb. 
     end 
 // Traffic lights state machine 
     always @ (posedge clk or negedge reset_n) 
     begin 
     if (reset_n == 1'b0) 
      begin // Switch OFF all lights to start with. 
          MR1 <= 1'b0 ; 
          MR2 <= 1'b0 ; 
          MG1 <= 1'b0 ; 
          MG2 <= 1'b0 ; 
          MY1 <= 1'b0 ; 
          MY2 <= 1'b0 ; 
          MLT1 <= 1'b0 ; 
          MLT2 <= 1'b0 ; 
          SR1 <= 1'b0 ; 
          SR2 <= 1'b0 ; 
          SY1 <= 1'b0; 
          SY2 <= 1'b0; 
          SG1 <= 1'b0 ; 
          SG2 <= 1'b0 ; 
          SLT1 <= 1'b0 ; 
          SLT2 <= 1'b0 ; 
         // Also, switch OFF the timers. 
          start_timer_1 <= 1'b0 ; 
          start_timer_2 <= 1'b0 ; 
          start_timer_3 <= 1'b0 ; 
          state <= `S0 ; 
      end // Initialize the state when the system is reset. 
  else 
  case (state) 
  `S0: 
       if (blink == 1'b1) 
        state <= `S12 ; // Change to the blink state. 
       else 
       begin 
       MG1 <= 1'b1 ; // Switch ON main 
       MG2 <= 1'b1 ; // green lights and 
       SR1 <= 1'b1 ; // side red lights. 
       SR2 <= 1'b1 ; 
       // Switch OFF all other lights not wanted. 
       MR1 <= 1'b0 ; 
       MR2 <= 1'b0 ; 
       MY1 <= 1'b0 ; 
       MY2 <= 1'b0 ; 
       MLT1 <= 1'b0; 
       MLT2 <= 1'b0; 
       SY1 <= 1'b0 ; 
       SY2 <= 1'b0 ; 
       SG1 <= 1'b0 ; 
       SG2 <= 1'b0 ; 
       SLT1 <= 1'b0 ; 
       SLT2 <= 1'b0 ; 
       if (cnt2_reg == `load_cnt2) 
       // This corresponds to 45 s timing of timer 1. 
       begin 
           start_timer_1 <= 1'b0 ; 
       // Stop the timer if the terminal count is reached. 
           state <= `S1 ; // Change the state. 
       end 
       else 
       begin 
           start_timer_1 <= 1'b1; // Otherwise, let it run. 
           state <= `S0 ; 
      // Remain in the same state until the terminal count is reached. 
       end 
       end 
  `S1: 
      if (blink == 1'b1) 
        state <= `S12 ; //Change to the blink state. 
      else 
      begin 
      // Switch ON main yellow lights and side red lights. 
          MY1 <= 1'b1 ; 
          MY2 <= 1'b1 ; 
          SR1 <= 1'b1 ; 
          SR2 <= 1'b1 ; 
          MG1 <= 1'b0 ; 
          MG2 <= 1'b0 ; 
          MR1 <= 1'b0 ; 
          MR2 <= 1'b0 ; 
          MLT1 <= 1'b0 ; 
          MLT2 <= 1'b0 ; 
          SY1 <= 1'b0 ; 
          SY2 <= 1'b0 ; 
          SG1 <= 1'b0 ; 
          SG2 <= 1'b0 ; 
          SLT1 <= 1'b0 ; 
          SLT2 <= 1'b0 ; 
       if (cnt3_reg == `load_cnt3) 
        // This corresponds to 5 s timing of timer 2. 
       begin 
           start_timer_2 <= 1'b0 ; 
           // Stop the timer if the terminal count is reached. 
           state <= `S2 ; // Change the state. 
       end 
       else 
       begin 
           start_timer_2 <= 1'b1 ; // Otherwise, let it run. 
           state <= `S1 ; 
       // Remain in the same state until the terminal count is reached. 
       end 
       end 
  `S2: 
       if (blink == 1'b1) 
           state <= `S12 ; // Change to the blink state. 
       else 
       begin // Switch ON main red lights, main road1 right, 
       // main road1 left and side red lights 
           MR1 <= 1'b1 ; 
           MR2 <= 1'b1 ; 
           MLT1 <= 1'b1 ; 
           SR1 <= 1'b1 ; 
           SR2 <= 1'b1 ; 
           // Switch OFF all other lights not wanted. 
           MY1 <= 1'b0 ; 
           MY2 <= 1'b0 ; 
           MG1 <= 1'b0 ; 
           MG2 <= 1'b0 ; 
           MLT2 <= 1'b0 ; 
           SY1 <= 1'b0 ; 
           SY2 <= 1'b0 ; 
           SG1 <= 1'b0 ; 
           SG2 <= 1'b0 ; 
           SLT1 <= 1'b0 ; 
           SLT2 <= 1'b0 ; 
           if (cnt4_reg == `load_cnt4) 
            // This corresponds to 25 s timing of timer 3. 
            begin 
                start_timer_3 <= 1'b0 ; 
            // Stop the timer if the terminal count is reached. 
                state <= `S3 ; // Change the state. 
            end 
            else 
            begin 
                start_timer_3 <= 1'b1 ; 
                // Otherwise, let it run. 
                state <= `S2 ; 
            // Remain in the same state until the terminal count is reached. 
    end 
    end 
   `S3: 
        if (blink == 1'b1) 
            state <= `S12 ; // Change to the blink state. 
        else 
        begin 
        // Switch ON main red, main road1 yellow light and side red lights. 
            MR1 <= 1'b1 ; 
            MR2 <= 1'b1 ; 
            MY1 <= 1'b1 ; 
            MY2 <= 1'b1 ; 
            SR1 <= 1'b1 ; 
            SR2 <= 1'b1 ; 
            // Switch OFF all other lights not wanted. 
            MG1 <= 1'b0 ; 
            MG2 <= 1'b0 ; 
            MLT1 <= 1'b0 ; 
            MLT2 <= 1'b0 ; 
            SG1 <= 1'b0 ; 
            SG2 <= 1'b0 ; 
            SY1 <= 1'b0 ; 
            SY2 <= 1'b0 ; 
            SLT1 <= 1'b0 ;
            SLT2 <= 1'b0 ; 
            if (cnt3_reg == `load_cnt3) 
         // This corresponds to 5 s timing of timer 2. 
            begin 
                start_timer_2 <= 1'b0 ; 
            // Stop the timer if the terminal count is reached. 
            state <= `S4 ; // Change the state. 
            end 
            else 
            begin 
                start_timer_2 <= 1'b1 ; // Otherwise, let it run. 
                 state <= `S3 ; 
            // Remain in the same state until the terminal count is reached. 
             end 
        end 
  `S4: 
         if (blink == 1'b1) 
            state <= `S12 ; // Change to the blink state. 
         else 
         begin 
             // Main red lights continue to be ON. Switch ON Main road 2 left, 
             // and also side red lights. 
             MR1 <= 1'b1 ; 
             MR2 <= 1'b1 ; 
             MLT2 <= 1'b1 ; 
             SR1 <= 1'b1 ; 
             SR2 <= 1'b1 ; 
             // Switch OFF all other lights not wanted. 
             MY1 <= 1'b0 ; 
             MY2 <= 1'b0 ; 
             MG1 <= 1'b0 ; 
             MG2 <= 1'b0 ; 
             MLT1 <= 1'b0 ; 
             SY1 <= 1'b0 ; 
             SY2 <= 1'b0 ; 
             SG1 <= 1'b0 ; 
             SG2 <= 1'b0 ; 
             SLT1 <= 1'b0 ; 
             SLT2 <= 1'b0 ; 
             if (cnt4_reg == `load_cnt4) 
             // This corresponds to 25 s timing of timer 3. 
             begin 
                start_timer_3 <= 1'b0 ; 
             // Stop the timer if the terminal count is reached. 
                state <= `S5 ; 
            // Change the state. 
            end 
            else 
            begin 
                start_timer_3 <= 1'b1 ; // Otherwise, let it run. 
                state <= `S4 ; 
            // Remain in the same state until the terminal count is reached. 
            end 
            end 
  `S5: 
         if (blink == 1'b1) 
            state <= `S12 ; // Change to the blink state. 
         else 
         begin 
         // Switch ON main red lights, MY2, and side yellow lights. 
             MR1 <= 1'b1 ; 
             MR2 <= 1'b1 ; 
             MY2 <= 1'b1 ; 
             SY1 <= 1'b1 ; 
             SY2 <= 1'b1 ; 
            // Switch OFF all other lights not wanted. 
             MY1 <= 1'b0 ; 
             MG1 <= 1'b0 ; 
             MG2 <= 1'b0 ; 
             MLT1 <= 1'b0 ; 
             MLT2 <= 1'b0 ; 
             SR1 <= 1'b0 ; 
             SR2 <= 1'b0 ; 
             SG1 <= 1'b0 ; 
             SG2 <= 1'b0 ; 
             SLT1 <= 1'b0 ; 
             SLT2 <= 1'b0 ; 
         if (cnt3_reg == `load_cnt3) 
         // This corresponds to 5 s timing of timer 2. 
         begin 
             start_timer_2 <= 1'b0 ; 
             // Stop the timer if the terminal count is reached. 
             state <= `S6 ; // Change the state. 
         end 
         else 
         begin 
             start_timer_2 <= 1'b1 ; // Otherwise, let it run. 
             state <= `S5 ; 
         // Remain in the same state until the terminal count is reached. 
         end 
         end 
  `S6: 
          if (blink == 1'b1) 
            state <= `S12 ; // Change to the blink state. 
          else 
          begin 
          // Switch ON main red lights and side green lights. 
          MR1 <= 1'b1 ; 
          MR2 <= 1'b1 ; 
          SG1 <= 1'b1 ; 
          SG2 <= 1'b1 ; 
          // Switch OFF all other lights not wanted. 
          MY1 <= 1'b0 ; 
          MY2 <= 1'b0 ; 
          MG1 <= 1'b0 ; 
          MG2 <= 1'b0 ; 
          MLT1 <= 1'b0 ; 
          MLT2 <= 1'b0 ; 
          SR1 <= 1'b0 ; 
          SR2 <= 1'b0 ; 
          SY1 <= 1'b0 ; 
          SY2 <= 1'b0 ; 
          SLT1 <= 1'b0 ; 
          SLT2 <= 1'b0 ; 
          if (cnt4_reg == `load_cnt4) 
          // This corresponds to 25 s timing of timer 1. 
          begin 
            start_timer_3 <= 1'b0 ; 
          // Stop the timer if the terminal count is reached. 
            state <= `S7 ; // Change the state. 
          end 
          else 
          begin 
            start_timer_3 <= 1'b1 ; // Otherwise, let it run. 
            state <= `S6 ; 
          // Remain in the same state until the terminal count is reached. 
          end 
          end 
  `S7: 
         if (blink == 1'b1) 
            state <= `S12 ; // Change to the blink state. 
         else 
         begin // Let Main roads red be ON, 
             MR1 <= 1'b1 ; 
             MR2 <= 1'b1 ; // side roads yellow ON and 
             SY1 <= 1'b1 ; 
             SY2 <= 1'b1 ;
             MY1 <= 1'b0 ; // switch OFF all unwanted 
             MY2 <= 1'b0 ; // lights. 
             MG1 <= 1'b0 ; 
             MG2 <= 1'b0 ; 
             MLT1 <= 1'b0 ; 
             MLT2 <= 1'b0 ; 
             SR1 <= 1'b0 ; 
             SR2 <= 1'b0 ; 
             SG1 <= 1'b0 ; 
             SG2 <= 1'b0 ; 
             SLT1 <= 1'b0 ; 
             SLT2 <= 1'b0 ; 
             if (cnt3_reg == `load_cnt3) 
               // This corresponds to 5 s timing of timer 2. 
             begin 
               start_timer_2 <= 1'b0 ; 
               // Stop the timer if the terminal count is reached. 
               state <= `S8 ; 
               // Change the state to the eighth sequence. 
             end 
           else 
           begin 
               start_timer_2 <= 1'b1 ; // Otherwise, let it run. 
               state <= `S7 ; 
           // Remain in the same state until the terminal count is reached. 
           end 
           end 
  `S8: 
       if (blink == 1'b1) 
           state <= `S12 ; // Change to the blink state. 
       else 
       begin 
           MR1 <= 1'b1 ; 
           MR2 <= 1'b1 ; // Let Main roads red be ON and 
           SR1 <= 1'b1 ; 
           SR2 <= 1'b1 ; // switch ON side roads red. 
           SLT1 <= 1'b1 ; // Also switch ON side road1 left. 
           MY1 <= 1'b0 ; // Switch OFF all unwanted lights. 
           MY2 <= 1'b0 ; 
           MG1 <= 1'b0 ; 
           MG2 <= 1'b0 ; 
           MLT1 <= 1'b0 ; 
           MLT2 <= 1'b0 ; 
           SY1 <= 1'b0 ; 
           SY2 <= 1'b0 ; 
           SG1 <= 1'b0 ; 
           SG2 <= 1'b0 ; 
           SLT2 <= 1'b0 ; 
           if (cnt4_reg == `load_cnt4) 
           // This corresponds to 10 s timing of timer 3. 
           begin 
            start_timer_3 <= 1'b0 ; 
            // Stop the timer if the terminal count is reached. 
            state <= `S9 ; // Change the state. 
           end 
           else 
           begin 
               start_timer_3 <= 1'b1 ; // Otherwise, let it run. 
               state <= `S8 ; 
            // Remain in the same state until the terminal count is reached. 
           end 
        end 
  `S9: 
        if (blink == 1'b1) 
        state <= `S12 ; // Change to the blink state. 
        else 
        begin 
        MR1 <= 1'b1 ; 
        MR2 <= 1'b1 ; // Retain Main roads red and 
        SR1 <= 1'b1 ; 
        SR2 <= 1'b1 ; // switch ON side roads red. 
        SY2 <= 1'b1 ; 
        SY1 <= 1'b1 ; // Switch ON side roads yellow. 
        // Switch OFF all unwanted lights. 
        MY1 <= 1'b0 ; 
        MY2 <= 1'b0 ; 
        MG1 <= 1'b0 ; 
        MG2 <= 1'b0 ; 
        MLT1 <= 1'b0 ; 
        MLT2 <= 1'b0 ; 
        SY1 <= 1'b0 ; 
        SG1 <= 1'b0 ; 
        SG2 <= 1'b0 ; 
        SLT1 <= 1'b0 ; 
        SLT2 <= 1'b0 ; 
        if (cnt3_reg == `load_cnt3) 
        // This corresponds to 5 s timing of timer 2. 
        begin 
            start_timer_2 <= 1'b0 ; 
            // Stop the timer if the terminal count is reached. 
            state <= `S10 ; 
        // Change the state to the first sequence. 
        end 
        else 
        begin 
            start_timer_2 <= 1'b1 ; // Otherwise, let it run. 
            state <= `S9 ; 
         // Remain in the same state until the terminal count is reached. 
        end 
       end 
  `S10: 
        if (blink == 1'b1) 
            state <= `S12 ; // Change to the blink state. 
        else 
        begin 
            MR1 <= 1'b1 ; // Retain Main roads red and 
            MR2 <= 1'b1 ; // switch ON side roads red. 
            SR1 <= 1'b1 ; 
            SR2 <= 1'b1 ; // Switch ON side road 2 left. 
            SLT2 <= 1'b1 ; //Switch OFF all other lights. 
            MY1 <= 1'b0 ; 
            MY2 <= 1'b0 ; 
            MG1 <= 1'b0 ; 
            MG2 <= 1'b0 ; 
            MLT1 <= 1'b0 ; 
            MLT2 <= 1'b0 ; 
            SY1 <= 1'b0 ; 
            SY2 <= 1'b0 ; 
            SG1 <= 1'b0 ; 
            SG2 <= 1'b0 ; 
            SLT1 <= 1'b0 ; 
            if (cnt4_reg == `load_cnt4) 
            // This corresponds to 10 s timing of timer 3. 
            begin 
                start_timer_3 <= 1'b0 ; 
               // Stop the timer if the terminal count is reached. 
                state <= `S11 ; // Change the state. 
            end 
            else 
            begin 
                start_timer_3 <= 1'b1 ; // Otherwise, let it run. 
                state <= `S10 ; 
            // Remain in the same state until the terminal count is reached. 
            end 
          end 
  `S11: 
         if (blink == 1'b1) 
            state <= `S12 ; // Change to the blink state.
         else 
         begin 
             MY1 <= 1'b1 ; // Switch ON Main roads yellow, 
             MY2 <= 1'b1 ; // side roads red, SY2 and 
             SR1 <= 1'b1 ; 
             SR2 <= 1'b1 ; 
             SY2 <= 1'b1 ; 
             SY1 <= 1'b0 ; // all other lights OFF. 
             MR1 <= 1'b0 ; 
             MR2 <= 1'b0 ; 
             MG1 <= 1'b0 ; 
             MG2 <= 1'b0 ; 
             MLT1 <= 1'b0 ; 
             MLT2 <= 1'b0 ; 
             SG1 <= 1'b0 ; 
             SG2 <= 1'b0 ; 
             SLT1 <= 1'b0 ; 
             SLT2 <= 1'b0 ; 
             if (cnt3_reg == `load_cnt3) 
              // This corresponds to 5 s timing of timer 2. 
             begin 
                start_timer_2 <= 0 ; 
              // Stop the timer if the terminal count is reached. 
                state <= `S0 ; 
              // Change the state to the first sequence. 
             end 
             else 
             begin 
                 start_timer_2 <= 1'b1 ; // Otherwise, let it run. 
                 state <= `S11 ; 
             // Remain in the same state until the terminal count is reached. 
             end 
          end 
  `S12: 
          if (blink == 1'b1) 
          begin 
              begin
              MR1 <= 1'b0 ; // Switch OFF all lights 
              MR2 <= 1'b0 ; // except yellow. 
              MG1 <= 1'b0 ; 
              MG2 <= 1'b0 ; 
              MLT1 <= 1'b0 ; 
              MLT2 <= 1'b0 ; 
              SR1 <= 1'b0 ; 
              SR2 <= 1'b0 ; 
              SG1 <= 1'b0 ; 
              SG2 <= 1'b0 ; 
              SLT1 <= 1'b0 ; 
              SLT2 <= 1'b0 ; 
              end 
          if(cnt5_reg == `load_cnt5) 
          begin // Blink all yellow lights. 
               SY1 <= ~SY1 ; 
               SY2 <= ~SY2 ; 
               MY1 <= ~MY1 ; 
               MY2 <= ~MY2 ; 
               state <= `S12 ; 
               // Remain in the same state until the terminal count is reached. 
          end 
          else 
              state <= `S12 ; 
        end 
     
       else 
          state <= `S0 ; // Change the state to the first sequence. 
      default: state <= `S0 ; 
   endcase 
   end 
endmodule