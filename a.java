import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.api.datastream.DataStream;
import org.apache.flink.connector.jdbc.JdbcConnectionOptions;
import org.apache.flink.connector.jdbc.JdbcExecutionOptions;
import org.apache.flink.connector.jdbc.JdbcSink;
import org.apache.flink.connector.jdbc.JdbcInputFormat;
import org.apache.flink.api.common.typeinfo.Types;

public class MySQLSyncJob {

    public static void main(String[] args) throws Exception {
        StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();

        DataStream<Tuple2<Integer, String>> sourceStream = env.createInput(
            JdbcInputFormat.buildJdbcInputFormat()
                .setDrivername("com.mysql.cj.jdbc.Driver")
                .setDBUrl("jdbc:mysql://source_host:source_port/source_db")
                .setUsername("source_user")
                .setPassword("source_password")
                .setQuery("SELECT id, name FROM table1")
                .setRowTypeInfo(Types.TUPLE(Types.INT, Types.STRING))
                .finish()
        );

        sourceStream.addSink(
            JdbcSink.sink(
                "INSERT INTO table2 (id, name) VALUES (?, ?)",
                (statement, record) -> {
                    statement.setInt(1, record.f0);
                    statement.setString(2, record.f1);
                },
                JdbcExecutionOptions.builder()
                    .withBatchSize(1000)
                    .withBatchIntervalMs(200)
                    .build(),
                new JdbcConnectionOptions.JdbcConnectionOptionsBuilder()
                    .withUrl("jdbc:mysql://sink_host:sink_port/sink_db")
                    .withDriverName("com.mysql.cj.jdbc.Driver")
                    .withUsername("sink_user")
                    .withPassword("sink_password")
                    .build()
            )
        );

        env.execute("MySQL Table Sync Job");
    }
}
