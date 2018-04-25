with McKae.XML.EZ_Out.Text_File;

package body AJUnitGen is

   ---------------
   -- Add_Suite --
   ---------------

   procedure Add_Suite (Col : in out Collection; Suite : Test_Suite'Class) is
   begin
      Col.Append (Test_Suite (Suite));
   end Add_Suite;

   --------------
   -- Add_Case --
   --------------

   procedure Add_Case (Suite : in out Test_Suite; Test : Test_Case) is
   begin
      Suite.Tests.Append (Test);
      Suite.Size := Suite.Size + 1;
      Suite.Counters (Test.Outcome) := Suite.Counters (Test.Outcome) + 1;
   end Add_Case;

   ---------------
   -- New_Suite --
   ---------------

   function New_Suite (Name : String) return Test_Suite is
   begin
      return (Name'Length, Name, others => <>);
   end New_Suite;

   --------------
   -- New_Case --
   --------------

   function New_Case (Name      : String;
                      Outcome   : Outcomes := Pass;
                      Classname : String   := "") return Test_Case is
   begin
      return (Name'Length,
              Classname'Length,
              Name,
              Outcome,
              Classname);
   end New_Case;

   -------------------
   -- To_Collection --
   -------------------

   function To_Collection (Suite : Test_Suite) return Collection'Class is
      Result : Collection;
   begin
      Result.Append (Suite);
      return Result;
   end To_Collection;

   -----------
   -- Write --
   -----------

   procedure Write (Col : Collection; File : Ada.Text_IO.File_Type) is
      use McKae.XML.EZ_Out.Text_File;
      Id : Natural := 0;
   begin
      Output_XML_Header (File);

      Start_Element (File, "testsuites");

      for S of Col loop
         Start_Element (File, "testsuite",
                        ("name" = S.Name,
                         "id" = Id,
                         "tests" = S.Size,
                         "errors" = S.Counters (Error),
                         "failures" = S.Counters (Fail),
                         "skipped" = S.Counters (Skip)));

         for T of S.Tests loop
            Output_Element (File, "testcase",
                            Content => "",
                            Attrs   =>
                              ("name" = T.Name,
                               "classname" = T.Classname,
                               "status" = T.Outcome'Img));
         end loop;

         End_Element (File, "testsuite");
         Id := Id + 1;
      end loop;

      End_Element (File, "testsuites");
   end Write;

end AJUnitGen;