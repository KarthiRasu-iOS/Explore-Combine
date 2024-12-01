//
//  Publishers.swift
//  Explore-Combine
//
//  Created by Karthi Rasu on 01/12/24.
//


import Combine

class PublishersExample {
    var pulisherCancellable =  Set<AnyCancellable>()
    init(){
//        currentValueSubject()
        passthroughSubject()
//        just()
    }
}


//MARK: - CurrentValueSubject

extension PublishersExample {
    
    /* Output :
     Initial Value :  0
     New Value 5
     New Value 10
     After send new value 10
     New Value 10
     New Value 20
     Completion Status :  finished
     */
    func currentValueSubject() {
        
        let current_subject = CurrentValueSubject<Int,Never>(0);
        
        print("Initial Value : ",current_subject.value)
        
        current_subject.send(5)
        
        current_subject.sink { onComplete in
            print("Completion Status : ",onComplete)
        } receiveValue: { newValue in
            print("New Value",newValue)
        }.store(in: &pulisherCancellable)


        
        current_subject.send(10)
        
        print("After send new value",current_subject.value)
        
        current_subject.send(10)
        
        current_subject.send(20)
        
        current_subject.send(completion: .finished)
        
        //Once the completion finished it always through completion status only
        
//        current_subject.sink { onComplete in
//            print("OnComplete 2 ",onComplete)
//        } receiveValue: { value in
//            print("value 2",value)
//        }.store(in: &pulisherCancellable)
//
//        current_subject.send(100)
//        
//        current_subject.sink { onComplete in
//            print("OnComplete 3 ",onComplete)
//        } receiveValue: { value in
//            print("value 3",value)
//        }.store(in: &pulisherCancellable)
    }
}

//MARK: - PassthroughSubject

extension PublishersExample {
    
    //Output : New Value 20
    
    func passthroughSubject() {
        
        let passThrough_subject = PassthroughSubject<Int,Never>()
        
        //It doesn't store value unlike currentValueSubject
        
        //print("Initial Value : ",passThrough_subject)
        // passThrough Publisher listen chagens after the subscription
        
        passThrough_subject.send(10)
        
        passThrough_subject.sink { _ in
            print("Completion")
        } receiveValue: { newValue in
            print("New Value",newValue)
        }.store(in: &pulisherCancellable)
        
        passThrough_subject.send(20)
        
        passThrough_subject.send(20)
        
        passThrough_subject.send(10)
        
        passThrough_subject.send(completion: .finished)
    }
}

//MARK: - Just

extension PublishersExample {
    /*
     Output :
     Value 10
     Completion Status: finished
     */
    func just() {
        let just_subject = Just<Int>(10)
        
        just_subject.sink { onComplete in
            print("Completion Status:",onComplete)
        } receiveValue: { value in
            print("Value",value)
        }.store(in: &pulisherCancellable)

    }
}
