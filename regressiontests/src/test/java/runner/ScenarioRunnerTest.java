package runner;

import com.epam.reportportal.karate.KarateReportPortalRunner;
import org.junit.jupiter.api.Test;

public class ScenarioRunnerTest {
    @Test
    void testParallel() {
        KarateReportPortalRunner
                .path("classpath:features")
                .outputCucumberJson(true)
                .tags("~@ignore")
                .parallel(1);
    }
}
