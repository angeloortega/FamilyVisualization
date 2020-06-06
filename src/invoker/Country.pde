public class Country {
    private String countryCode;
    private String countryName;
    private double population;
    private double gdp;
    private double cpi;

    public Country(String countryCode, String countryName, double population, double gdp, double cpi) {
        this.countryCode = countryCode;
        this.countryName = countryName;
        this.population = population;
        this.gdp = gdp;
        this.cpi = cpi;
    }

    public String getCountryCode() {
        return this.countryCode;
    }

    public void setCountryCode(String countryCode) {
        this.countryCode = countryCode;
    }

    public String getCountryName() {
        return this.countryName;
    }

    public void setCountryName(String countryName) {
        this.countryName = countryName;
    }

    public double getPopulation() {
        return this.population;
    }

    public void setPopulation(double population) {
        this.population = population;
    }

    public double getGdp() {
        return this.gdp;
    }

    public void setGdp(double gdp) {
        this.gdp = gdp;
    }

    public double getCpi() {
        return this.cpi;
    }

    public void setCpi(double cpi) {
        this.cpi = cpi;
    }

    @Override
    public String toString() {
        return "{" +
            "  País:='" + getCountryName() + "'" +
            ", población='" + getPopulation() + "'" +
            ", PIB='" + getGdp() + "'" +
            ", IPC='" + getCpi() + "'" +
            "}";
    }

}
