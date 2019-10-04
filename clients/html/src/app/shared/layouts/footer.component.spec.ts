import { FooterComponent } from './footer.component';
import { HeaderFooterConfigurationConsumer } from '../../configuration/header_footer/header_footer_configuration.service';
import { HeaderFooterConfigurationResource } from '../../configuration/header_footer/header_footer_configuration.resources';

class MockHFConfigurationProvider {
  getHeaderFooterConfiguration(consumer : HeaderFooterConfigurationConsumer) : any {
    consumer.applyHeaderFooterConfiguration(mockResource);
  }
}

var mock_primary_color_code = "My Primary Color Code";
var mock_customer_support_number = "(555) 555 - 5555";

var mockResource : HeaderFooterConfigurationResource = {
  call_center_phone: mock_customer_support_number,
  colors: {
    primary_color: mock_primary_color_code
  }
};

describe("FooterComponent",
  () => {
    it("initializes successfully, with the default benefit year", () => {
      var mockProvider = new MockHFConfigurationProvider();
      var component = new FooterComponent(mockProvider);
      expect(component.benefit_year).toBe(new Date().getFullYear() + 1);
    });
    it("assigns the properties on when the component is initialized", () => {
      var mockProvider = new MockHFConfigurationProvider();
      var component = new FooterComponent(mockProvider);
      component.ngOnInit();
      expect(component.customer_support_number).toEqual(mock_customer_support_number);
      expect(component.primaryColorCode).toBe(mock_primary_color_code);
    });
  }
);