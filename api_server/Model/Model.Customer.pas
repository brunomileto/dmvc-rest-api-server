unit Model.Customer;

interface

uses
  System.Generics.Collections, uDmConnection, System.SysUtils;

type
  TCustomer = class
  private
    Fcustomer: String;
    Fcountry: String;
    Fcustomer_cod: Integer;
    Fcity: String;
    procedure Setcity(const Value: String);
    procedure Setcountry(const Value: String);
    procedure Setcustomer(const Value: String);
    procedure Setcustomer_cod(const Value: Integer);
  public
    property customer_cod : Integer read Fcustomer_cod write Setcustomer_cod;
    property customer     : String  read Fcustomer     write Setcustomer;
    property city         : String  read Fcity         write Setcity;
    property country      : String  read Fcountry      write Setcountry;

    class function GetAllCustomers                  : TObjectList<TCustomer>;

    class function getById(customerId : Integer)    : TCustomer;


  end;

implementation

{ TCustomer }

uses Data.DB;

class function TCustomer.getById(customerId: Integer): TCustomer;
const
  QUERY = 'SELECT * FROM CUSTOMER WHERE CUST_NO = ';
var
  aCustomer     : TCustomer;
  DmConnection  : TDmConnection;
  aDataSet      : TDataSet;
begin
  DmConnection := TDmConnection.Create(nil);
  try
    DmConnection.FDConnection.ExecSQL(QUERY + IntToStr(customerId), aDataSet);

    aCustomer := TCustomer.Create;

    aCustomer.customer_cod := aDataSet.FieldByName('CUST_NO' ).AsInteger;
    aCustomer.customer     := aDataSet.FieldByName('CUSTOMER').AsString;
    aCustomer.country      := aDataSet.FieldByName('COUNTRY' ).AsString;
    aCustomer.city         := aDataSet.FieldByName('CITY'    ).AsString;

    result := aCustomer;
  finally
    DmConnection.Free;
  end;
end;

class function TCustomer.GetAllCustomers: TObjectList<TCustomer>;
const
  QUERY = 'SELECT * FROM CUSTOMER';
var
  aCustomer    : TCustomer;
  allCustomers : TObjectList<TCustomer>;
  DmConnection : TDmConnection;
  aDataSet     : TDataSet;
begin
  DmConnection := TDmConnection.Create(nil);
  try
    DmConnection.fdConnection.ExecSQL(QUERY, aDataSet);
    try
      allCustomers := TObjectList<TCustomer>.Create;
      aDataSet.First;
      while not aDataSet.Eof do begin
        aCustomer := TCustomer.Create;
        aCustomer.customer_cod := aDataSet.FieldByName('CUST_NO' ).AsInteger;
        aCustomer.customer     := aDataSet.FieldByName('CUSTOMER').AsString;
        aCustomer.country      := aDataSet.FieldByName('COUNTRY' ).AsString;
        aCustomer.city         := aDataSet.FieldByName('CITY'    ).AsString;
        allCustomers.Add(aCustomer);
        aDataSet.Next;
      end;
      result := allCustomers;
    finally
      aDataSet.Free;
    end;
  finally
    DmConnection.Free;
  end;
end;

procedure TCustomer.Setcity(const Value: String);
begin
  Fcity := Value;
end;

procedure TCustomer.Setcountry(const Value: String);
begin
  Fcountry := Value;
end;

procedure TCustomer.Setcustomer(const Value: String);
begin
  Fcustomer := Value;
end;

procedure TCustomer.Setcustomer_cod(const Value: Integer);
begin
  Fcustomer_cod := Value;
end;

end.
