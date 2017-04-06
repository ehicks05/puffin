package net.ehicks.bts;

import net.ehicks.common.Common;
import net.ehicks.eoi.DBMap;
import net.ehicks.eoi.EOI;
import net.ehicks.eoi.SQLGenerator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletContext;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class Startup
{
    private static final Logger log = LoggerFactory.getLogger(Startup.class);

    static void loadProperties(ServletContext servletContext)
    {
        Properties properties = new Properties();

        try (InputStream input = servletContext.getResourceAsStream("/WEB-INF/bts.properties");)
        {
            properties.load(input);
        }
        catch (IOException e)
        {
            log.error(e.getMessage(), e);
        }

        SystemInfo.INSTANCE.setSystemStart(System.currentTimeMillis());
        SystemInfo.INSTANCE.setServletContext(servletContext);

        SystemInfo.INSTANCE.setAppName(Common.getSafeString(properties.getProperty("appName")));
        SystemInfo.INSTANCE.setDebugLevel(Common.stringToInt(properties.getProperty("debugLevel")));
        SystemInfo.INSTANCE.setDropCreateLoad(properties.getProperty("dropCreateLoad").equals("true"));

        SystemInfo.INSTANCE.setDbConnectionString(Common.getSafeString(properties.getProperty("dbConnectionString")));
        SystemInfo.INSTANCE.setDatabaseCacheInKBs(Common.stringToLong(properties.getProperty("databaseCacheInKBs")));

        SystemInfo.INSTANCE.setLogDirectory(properties.getProperty("logDirectory"));
        SystemInfo.INSTANCE.setBackupDirectory(properties.getProperty("backupDirectory"));

        servletContext.setAttribute("systemInfo", SystemInfo.INSTANCE);
    }

    static void loadDBMaps(ServletContext servletContext)
    {
        long subTaskStart = System.currentTimeMillis();
        DBMap.loadDbMaps(servletContext.getRealPath("/WEB-INF/classes/net/ehicks/bts/beans"), "net.ehicks.bts.beans");
        log.debug("Loaded DBMAPS in {} ms", (System.currentTimeMillis() - subTaskStart));
    }

    static void createTables()
    {
        long subTaskStart = System.currentTimeMillis();
        int tablesCreated = 0;
        for (DBMap dbMap : DBMap.dbMaps)
            if (!EOI.isTableExists(dbMap.tableName.toUpperCase()))
            {
                String createTableStatement = SQLGenerator.getCreateTableStatement(dbMap);
                EOI.executeUpdate(createTableStatement);
                tablesCreated++;

                for (String indexDefinition : dbMap.indexDefinitions)
                    EOI.executeUpdate(indexDefinition);
            }
        log.info("Autocreated {}/{} tables in {} ms", tablesCreated, DBMap.dbMaps.size(), (System.currentTimeMillis() - subTaskStart));
    }

    static void dropTables()
    {
        long subTaskStart;
        subTaskStart = System.currentTimeMillis();
        int tablesDropped = 0;
        for (DBMap dbMap : DBMap.dbMaps)
        {
            String tableName = dbMap.tableName.toUpperCase();
            try
            {
                if (EOI.isTableExists(tableName))
                {
                    log.debug("Dropping " + tableName + "...");
                    EOI.executeUpdate("drop table " + tableName);
                    tablesDropped++;
                }
            }
            catch (Exception e)
            {
                log.error("didnt drop {}", tableName);
            }
        }
        log.info("Dropped {}/{} existing tables in {} ms", tablesDropped, DBMap.dbMaps.size(), (System.currentTimeMillis() - subTaskStart));
    }
}
