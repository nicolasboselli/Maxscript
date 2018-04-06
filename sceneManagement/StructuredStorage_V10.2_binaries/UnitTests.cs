using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CalumMcLellan.StructuredStorage;
using System.IO;

namespace TestProject
{
    [TestClass]
    public class UnitTests
    {
        public static string s_testFile = @"C:\temp\teil1.par";
        [TestMethod]
        public void EnumerationTest()
        {
            Console.WriteLine(IntPtr.Size);
            using (PropertySets propertySets = new PropertySets(s_testFile, true))
            {
                DumpPropertySets(propertySets);
                if (propertySets.IsFamilyMaster)
                {
                    foreach (PropertySets member in propertySets.FamilyMembers)
                    {
                        DumpPropertySets(member);
                    }
                }
            }
        }

        [TestMethod]
        public void PropertyTypeTest()
        {
            using (PropertySets propertySets = new PropertySets(s_testFile, false))
            {
                Console.WriteLine("Before:");
                DumpPropertySets(propertySets);

                if (propertySets.Contains(PropertySetIds.UserDefinedProperties))
                {
                    /* Clear all custom properties */
                    propertySets[PropertySetIds.UserDefinedProperties].Delete();
                }

                PropertySet custom = propertySets.Add(PropertySetIds.UserDefinedProperties, false);

                custom.Add("TestString", "Hello");
                custom.Add("TestDate", DateTime.Now);
                custom.Add("TestDouble", 1.0d);
                custom.Add("TestBoolean", false);

                Console.WriteLine();
                Console.WriteLine("After:");
                DumpPropertySets(propertySets);
            }
        }

        [TestMethod]
        public void ModifyDeleteAddPropertyTest()
        {
            using (PropertySets propertySets = new PropertySets(s_testFile, false))
            {
                Console.WriteLine("Before:");
                DumpPropertySets(propertySets);

                PropertySet projectInfo = null;
                if (propertySets.Contains(PropertySetIds.ProjectInformation))
                {
                    projectInfo = propertySets[PropertySetIds.ProjectInformation];
                }
                else
                {
                    projectInfo = propertySets.Add(PropertySetIds.ProjectInformation, false);
                }
                
                Property docNumber = null;
                if (projectInfo.Contains(ProjectInfoIds.DocumentNumber))
                {
                    docNumber = projectInfo[ProjectInfoIds.DocumentNumber];
                }
                else
                {
                    docNumber = projectInfo.Add(ProjectInfoIds.DocumentNumber, string.Empty);
                }
                docNumber.Value = "Testing";
                Console.WriteLine();
                Console.WriteLine("After modification:");
                DumpPropertySets(propertySets);

                docNumber.Delete();
                Console.WriteLine();
                Console.WriteLine("After deletion:");
                DumpPropertySets(propertySets);

                docNumber = projectInfo.Add(ProjectInfoIds.DocumentNumber, "New property");
                Console.WriteLine();
                Console.WriteLine("After adding:");
                DumpPropertySets(propertySets);
            }
        }

        [TestMethod]
        public void DeleteAddPropertySetTest()
        {
            File.Copy(s_testFile, s_testFile + ".tmp");
            using (PropertySets propertySets = new PropertySets(s_testFile + ".tmp", false))
            {
                Console.WriteLine("Before deletion:");
                DumpPropertySets(propertySets);

                if (propertySets.Contains(PropertySetIds.SummaryInformation))
                {
                    propertySets[PropertySetIds.SummaryInformation].Delete();
                }

                PropertySet summaryInfo = propertySets.Add(PropertySetIds.SummaryInformation, false);

                summaryInfo.Add(SummaryInfoIds.Author, "Me");
                summaryInfo.Add(SummaryInfoIds.Created, DateTime.Now);

                Console.WriteLine();
                Console.WriteLine("After adding:");
                DumpPropertySets(propertySets);
            }
            File.Delete(s_testFile + ".tmp");
        }

        private static void DumpPropertySets(PropertySets propertySets)
        {
            foreach (PropertySet propertySet in propertySets)
            {
                Console.WriteLine(string.Format("{0} (Unicode: {1})", propertySet.Name, propertySet.IsUnicode));
                foreach (Property property in propertySet)
                {
                    Console.WriteLine(string.Format("\t{0} ({1}): {2}", property.Name, property.Id, property.Value));
                }
            }
        }
    }
}
